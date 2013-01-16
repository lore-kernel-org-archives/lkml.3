Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3APLf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:35:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3APLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:35:27 -0500
Date: Wed, 16 Jan 2013 13:35:22 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: close opened file
Message-ID: <20130116113522.GR11529@redhat.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please use "kvmtool:" prefix at the subject line.

On Wed, Jan 16, 2013 at 02:07:35AM +0100, Cong Ding wrote:
> The file should be closed before return.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  tools/kvm/builtin-setup.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/kvm/builtin-setup.c b/tools/kvm/builtin-setup.c
> index c5b0566..8b45c56 100644
> --- a/tools/kvm/builtin-setup.c
> +++ b/tools/kvm/builtin-setup.c
> @@ -159,12 +159,12 @@ static int copy_passwd(const char *guestfs_name)
>  		return -1;
>  
>  	ret = fprintf(file, "root:x:0:0:root:/root:/bin/sh\n");
> -	if (ret < 0)
> -		return ret;
> +	if (ret > 0)
> +		ret = 0;
>  
>  	fclose(file);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int make_guestfs_symlink(const char *guestfs_name, const char *path)
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
