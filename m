Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaBITic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:38:32 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:55682 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbaBITib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:38:31 -0500
Message-ID: <1391974709.25855.3.camel@x220>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 20:38:29 +0100
In-Reply-To: <1391971686-9517-25-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-25-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 19:38:29.0408 (UTC) FILETIME=[82266A00:01CF25CE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:48 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/mn10300/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
> index 94efb3e..af18047 100644
> --- a/arch/mn10300/Kconfig.debug
> +++ b/arch/mn10300/Kconfig.debug
> @@ -32,7 +32,7 @@ config KPROBES
>  
>  config GDBSTUB
>  	bool "Remote GDB kernel debugging"
> -	depends on DEBUG_KERNEL && DEPRECATED
> +	depends on DEBUG_KERNEL

But now you've enabled a lot of stuff that, as far as I can tell, could
not have been built since v2.6.39.

The proper fix would be to remove GDBSTUB and everything that depends on
it. I tried to do that once and it turned out to be much more work than
I expected. So perhaps we should just do s/DEPRECATED/BROKEN/ and let
the mn10300 maintainers deal with this.
 
>  	select DEBUG_INFO
>  	select FRAME_POINTER
>  	help


Paul Bolle

