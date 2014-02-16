Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaBPUac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:30:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53150 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752822AbaBPUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:30:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Len Brown <lenb@kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Remove Kconfig symbol ACPI_PROCFS
Date: Sun, 16 Feb 2014 21:45:17 +0100
Message-ID: <49750510.SeydVA5ctE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392570485.28866.10.camel@x220>
References: <1392570485.28866.10.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 16, 2014 06:08:05 PM Paul Bolle wrote:
> Nothing cares about ACPI_PROCFS.

Some defconfigs set it.  Care to remove it from them too?

> This has been the case since v2.6.38.
> This Kconfig symbol serves no purpose and its help text is now
> misleading. It can safely be removed. If this symbol would be needed
> again in the future it can be readded in a commit that adds code that
> actually uses it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep" only.
> 
> Michael Opdenacker did a previous attempt in
> https://lkml.org/lkml/2013/10/27/15 . That patch that needed some
> context changes, so I redid it. I also wrote a new commit explanation.
> It also addresses the reasons not to accept Michael's patch.
> 
>  drivers/acpi/Kconfig | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 4770de5..436111b 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -43,19 +43,6 @@ config ACPI_SLEEP
>  	depends on SUSPEND || HIBERNATION
>  	default y
>  
> -config ACPI_PROCFS
> -	bool "Deprecated /proc/acpi files"
> -	depends on PROC_FS
> -	help
> -	  For backwards compatibility, this option allows
> -	  deprecated /proc/acpi/ files to exist, even when
> -	  they have been replaced by functions in /sys.
> -
> -	  This option has no effect on /proc/acpi/ files
> -	  and functions which do not yet exist in /sys.
> -
> -	  Say N to delete /proc/acpi/ files that have moved to /sys/
> -
>  config ACPI_EC_DEBUGFS
>  	tristate "EC read/write access through /sys/kernel/debug/ec"
>  	default n
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
