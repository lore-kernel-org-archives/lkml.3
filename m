Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbbAMFY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:24:26 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:56432 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbbAMFYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:24:25 -0500
Date: Tue, 13 Jan 2015 14:24:04 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: fix scripts/headers.sh to see the correct Kbuild path
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <1417589535-15867-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417589535-15867-1-git-send-email-yamada.m@jp.panasonic.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20150113142404.CACA.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

IIRC, you mentioned scripts/headers.sh is pointless
and should be removed from the code base.

If so, this patch of mine has no point.
Could you consider removing scripts/headers.sh ?


Best Regards
Masahiro Yamada



On Wed,  3 Dec 2014 15:52:15 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> The exported headers were moved to "uapi" directories.
> We should check the existence of arch/*/include/uapi/asm/Kbuild.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
> 
>  scripts/headers.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/headers.sh b/scripts/headers.sh
> index 95ece06..b164336 100755
> --- a/scripts/headers.sh
> +++ b/scripts/headers.sh
> @@ -6,7 +6,7 @@ set -e
>  
>  do_command()
>  {
> -	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
> +	if [ -f ${srctree}/arch/$2/include/uapi/asm/Kbuild ]; then
>  		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
>  	else
>  		printf "Ignoring arch: %s\n" ${arch}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


