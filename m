Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaKMBNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:13:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53888 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752834AbaKMBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:13:10 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>
Subject: Re: [PATCH] powercap/rapl: fix build dependency on iosf_mbi
Date: Thu, 13 Nov 2014 02:34:06 +0100
Message-ID: <4658675.JHF4IagFMX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415818236-21741-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1415818236-21741-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 12, 2014 10:50:36 AM Jacob Pan wrote:
> RAPL on Atom depends on IOSF_MBI driver for setting
> floor frequency. This patch adds explicit dependency on
> CONFIG_IOSF_MB.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Applied, thanks!

> ---
>  drivers/powercap/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/powercap/Kconfig b/drivers/powercap/Kconfig
> index a7c81b5..85727ef 100644
> --- a/drivers/powercap/Kconfig
> +++ b/drivers/powercap/Kconfig
> @@ -17,7 +17,7 @@ if POWERCAP
>  # Client driver configurations go here.
>  config INTEL_RAPL
>  	tristate "Intel RAPL Support"
> -	depends on X86
> +	depends on X86 && IOSF_MBI
>  	default n
>  	---help---
>  	  This enables support for the Intel Running Average Power Limit (RAPL)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
