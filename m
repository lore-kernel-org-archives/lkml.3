Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaLHV6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:58:38 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55691 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbaLHV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:58:35 -0500
Message-ID: <1418075913.2058.71.camel@x220>
Subject: Re: [PATCH] kbuild: fix scripts/headers.sh to see the correct
 Kbuild path
From: Paul Bolle <pebolle@tiscali.nl>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Dec 2014 22:58:33 +0100
In-Reply-To: <1417589535-15867-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417589535-15867-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 21:58:33.0076 (UTC) FILETIME=[1BE0E340:01D01332]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masahiro,

On Wed, 2014-12-03 at 15:52 +0900, Masahiro Yamada wrote:
> The exported headers were moved to "uapi" directories.
> We should check the existence of arch/*/include/uapi/asm/Kbuild.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---

Does this patch fix any problems? If so, which? And why did no one
notice these problems before? Perhaps the commit explanation could
mention that.

See, none of this is obvious, at least to me, and I don't think people
reading the patch should be expected to figure this out themselves.

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

Thanks,


Paul Bolle

