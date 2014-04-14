Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaDNBiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:38:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17652 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDNBiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:38:16 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-50-534b3c06d875
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1397439375.24638.20.camel@kjgkr>
Subject: Re: [PATCH 1/7] f2fs: put the bio when issue_flush completed
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 14 Apr 2014 10:36:15 +0900
In-reply-to: <5347BAAF.9030004@cn.fujitsu.com>
References: <5347BAAF.9030004@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ102G+9gg5tdNhbP2w8wW1xa5G6x
	Z+9JFovLu+awObB4/D84idlj94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZbzokC14z13x/3sj
	awPjZs4uRk4OCQETiW2b7zND2GISF+6tZ+ti5OIQEljGKLFn8002mKKGE4eZQGwhgUWMEleX
	s4PYvAKCEj8m32MBsZkF1CUmzVvEDGGLSLx5fh7K1pZYtvA1M8TQV4wSd/b/YoFo1pVY8qYN
	zBYWcJX4sb4VaBkHBxtQw+b9BhC7FCXe7r/LCmKLCKhJPHt3iQlkDrNAN6PE2fWvwI5gEVCV
	WLDzNZjNKaAn8bX1EgtEs67E6RMPwWx+AVGJwwu3Q32pJLG7vZMdZJCEwDF2iR2TPzFBDBKQ
	+Db5EAvIERICshKbDkDVS0ocXHGDZQKj5CwkP89C8vMsJD/PQvLzAkaWVYyiqQXJBcVJ6UWm
	esWJucWleel6yfm5mxghETpxB+P9A9aHGJOB1k9klhJNzgdGeF5JvKGxmZGFqYmpsZG5pRlp
	wkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MK4wvbX/+dHb69jZnr4qey54q0Kj
	76pT+bFpOhmvme+/eOyynb3mTJHhlZlh77t9Fk9l9pLOS66S35lkrjjvdiu397or/4sX6Os+
	X93U/SKiP6X1tdKBlx9f3y+9uemKV77l77/T2sSO/DJ4G/AmvT21Y/etuJjuxR+OfrF2n3LE
	7ZXKPYWHea+VWIozEg21mIuKEwGnE8Cu5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV02G+9gg89vzC2etx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYM+cwY8FT7oq/fdOZGxhXcnYxcnJICJhINJw4zARhi0lcuLeeDcQWEljE
	KHF1OTuIzSsgKPFj8j2WLkYODmYBeYkjl7JBwswC6hKT5i1i7mLkAip/xShxZ/8vFoh6XYkl
	b9rAbGEBV4kf61vZQHrZBLQlNu83gBivKPF2/11WEFtEQE3i2btLTCBzmAW6GSXOrn8FtpdF
	QFViwc7XYDangJ7E19ZLLBDNuhKnTzwEs/kFRCUOL9zODHG/ksTu9k72CYxCs5CcPQvh7FlI
	zl7AyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzian0nvYFzVYHGIUYCDUYmHN2G7Z7AQ
	a2JZcWXuIUYJDmYlEd5tGV7BQrwpiZVVqUX58UWlOanFhxiTgQ6fyCwlmpwPTDR5JfGGxiZm
	RpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDo1Ows4+iXezBKh5/9Y2GF
	5devVwTN0pdOD/n967aekuCDRK2dtqIX1ply3fyjnWPn/Zv1iF7GyYYJE5exLjorrlucylF4
	wHFaWuGGBVOKDllP9VH8qBObtnxva4RJbCPXAaPDkTdLF5xbPHX5dbuP01glDLavOP1Kym1J
	Y9bMhwK9p996yNQqsRRnJBpqMRcVJwIAUSffMyoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,
Merged.
thank you. :)

2014-04-11 (금), 17:49 +0800, Gu Zheng:
> Put the bio when the flush cmd issued, it also can fix the following
> kmemleak:
> unreferenced object 0xffff8800270c73c0 (size 200):
>   comm "f2fs_flush-7:0", pid 27161, jiffies 4312127988 (age 988.503s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 40 07 81 19 01 88 ff ff  ........@.......
>     01 00 00 00 00 00 00 f0 11 14 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81559866>] kmemleak_alloc+0x72/0x96
>     [<ffffffff81156f7e>] slab_post_alloc_hook+0x28/0x2a
>     [<ffffffff811595b1>] kmem_cache_alloc+0xec/0x157
>     [<ffffffff8111924d>] mempool_alloc_slab+0x15/0x17
>     [<ffffffff81119513>] mempool_alloc+0x71/0x138
>     [<ffffffff81193548>] bio_alloc_bioset+0x93/0x18c
>     [<ffffffffa040f857>] issue_flush_thread+0x8d/0x145 [f2fs]
>     [<ffffffff8107ac16>] kthread+0xba/0xc2
>     [<ffffffff81571b2c>] ret_from_fork+0x7c/0xb0
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/segment.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 085f548..524b7ed 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -226,6 +226,7 @@ repeat:
>  			next = cmd->next;
>  			complete(&cmd->wait);
>  		}
> +		bio_put(bio);
>  		sm_i->dispatch_list = NULL;
>  	}
>  

-- 
Jaegeuk Kim
Samsung

