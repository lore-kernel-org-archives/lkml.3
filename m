Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaEUNeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:34:44 -0400
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:60716 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbaEUNen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:34:43 -0400
X-Greylist: delayed 1225 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 09:34:43 EDT
Message-ID: <537CA69F.7080603@elastichosts.com>
Date: Wed, 21 May 2014 14:14:07 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
Organization: Elastichosts Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dominique Martinet <dominique.martinet@cea.fr>,
        v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>
Subject: Re: [PATCH] 9P: fix return value in v9fs_fid_xattr_set
References: <20140521065219.GA15962@u-barrelet> <1400659332-21498-1-git-send-email-dominique.martinet@cea.fr>
In-Reply-To: <1400659332-21498-1-git-send-email-dominique.martinet@cea.fr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/14 09:02, Dominique Martinet wrote:
> v9fs_fid_xattr_set is supposed to return 0 on success.
> 
> This corrects the behaviour introduced in commit
> bdd5c28dcb8330b9074404cc92a0b83aae5606a
> "9p: fix return value in case in v9fs_fid_xattr_set()"
> 
> (The function returns a negative error on error, as expected)
> 
> Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
> ---
>  fs/9p/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
> index 04133a1..f95e01e 100644
> --- a/fs/9p/xattr.c
> +++ b/fs/9p/xattr.c
> @@ -156,7 +156,7 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
>  		offset += write_count;
>  		value_len -= write_count;
>  	}
> -	retval = offset;
> +	retval = 0;
>  err:
>  	p9_client_clunk(fid);
>  	return retval;
> 

This patch seems to be fixing the problem, thanks!
