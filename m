Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaA1GBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:01:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46309 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaA1GBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:01:36 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7efc6d0000039d3-d6-52e747bf61c7
Content-transfer-encoding: 8BIT
Message-id: <1390888811.25542.54.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: use inode mutex to keep atomicity of
 f2fs_falloc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 28 Jan 2014 15:00:11 +0900
In-reply-to: <000101cf1bd0$d1f6be70$75e43b50$@samsung.com>
References: <000101cf1bd0$d1f6be70$75e43b50$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zI9397s+DDI7M4LL43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldH9PrBgL2dF79Gl
	zA2M+9i7GDk5JARMJDpv3WWGsMUkLtxbz9bFyMUhJLCMUeLc1gNsMEWLX99lgkgsYpSY3N/P
	CpLgFRCU+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnzFjFD1L9klFg9r5sJol5XYkPTDrBeYYEI
	iefL7oD1sgloS2zebwASFhJQlHi7/y5YiYiAksSv+YtYIWZmSsx5PRnMZhFQlVi85irYSE4B
	K4kpE5ewQPRaSjzdeQ8szi8gKnF44Xaox5Qkdrd3soPcIyGwj13iQfM8ZohBAhLfJh8Cu0FC
	QFZi0wGoekmJgytusExglJiF5MtZCF/OQvLlAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5
	mxgh0TZxB+P9A9aHGJOBNk5klhJNzgdGa15JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MC5WWhE4o5rP9EbXOftjLI06rm1Pon4uu8FV8ttknvzc
	7Ukrn7hsnaAVddB6ttnij5cEs67EuDtsq91+rOndDKnSlvA1NalFjPHR6sx886yaiuJdVSrv
	1V572hWl4/3RotmdiTmmVntinLFx/ZqLdZfdns392SV2tlSjwZxDiKmWL/z8yscrlViKMxIN
	tZiLihMBo1c+WcwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd397s+DDBrusVn8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zofh9YsJezovfoUuYGxn3sXYycHBICJhKLX99lgrDFJC7cW8/WxcjFISSw
	iFFicn8/K0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+SUWL1vG4miHpdiQ1N
	O8B6hQUiJJ4vuwPWyyagLbF5vwFIWEhAUeLt/rtgJSICShK/5i9ihZiZKTHn9WQwm0VAVWLx
	mqtgIzkFrCSmTFzCAtFrKfF05z2wOL+AqMThhduZIe5Xktjd3sk+gVFoFpKrZyFcPQvJ1QsY
	mVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfyM+kdjKsaLA4xCnAwKvHwPuh+FiTEmlhW
	XJl7iFGCg1lJhPfsFKAQb0piZVVqUX58UWlOavEhxmSgwycyS4km5wPTTF5JvKGxiZmRpZGZ
	hZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1ME5ZkGhp4H3PZ8Vub/e0+7cyl/xm
	jzBZy8txPLl++Yo6+dy/v6oOM7Cc7U2rdpE5YbykYn/d84wXDawFBufSrQ5PivsQsaDHKOOl
	tGPsly/ZW/rNq6OWr79wQaMhdIepyIPV8Xt7KxZsmmg+5XnGAllplam16aE8/3b2Wjy4dGON
	WPIfWdaJZ5VYijMSDbWYi4oTASUd21MpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-01-28 (화), 10:29 +0800, Chao Yu:
> Previously without protection of inode mutex, f2fs_falloc and other data
> correlated operations will interfere with each other.

Could you explain a little bit more what kind of scenarios wrt this?


> So let's use inode mutex to keep atomicity of f2fs_falloc.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/file.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 85e91ca..ece380f 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -559,6 +559,8 @@ static long f2fs_fallocate(struct file *file, int mode,
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>  		return -EOPNOTSUPP;
>  
> +	mutex_lock(&inode->i_mutex);
> +
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		ret = punch_hole(inode, offset, len);
>  	else
> @@ -568,6 +570,9 @@ static long f2fs_fallocate(struct file *file, int mode,
>  		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  		mark_inode_dirty(inode);
>  	}
> +
> +	mutex_unlock(&inode->i_mutex);
> +
>  	trace_f2fs_fallocate(inode, mode, offset, len, ret);
>  	return ret;
>  }

-- 
Jaegeuk Kim
Samsung

