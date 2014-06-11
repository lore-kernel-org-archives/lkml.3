Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaFKTAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:00:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47841 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaFKTAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:00:37 -0400
Date: Wed, 11 Jun 2014 21:00:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, m.chehab@samsung.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7 v3] trace, AER: Move trace into unified interface
Message-ID: <20140611190035.GC14923@pd.tnic>
References: <1402475691-30045-1-git-send-email-gong.chen@linux.intel.com>
 <1402475691-30045-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402475691-30045-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:34:46AM -0400, Chen, Gong wrote:
> AER uses a separate trace interface by now. To make it
> consistent, move it into unified RAS trace interface.
> 
> v3 -> v2: change dependency rule of RAS_TRACE.
> v2 -> v1: remove unnecessary dependency in drivers/ras/Kconfig.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/pci/pcie/aer/Kconfig           |  1 +
>  drivers/pci/pcie/aer/aerdrv_errprint.c |  4 +-
>  include/ras/ras_event.h                | 64 ++++++++++++++++++++++++++++
>  include/trace/events/ras.h             | 77 ----------------------------------
>  4 files changed, 66 insertions(+), 80 deletions(-)
>  delete mode 100644 include/trace/events/ras.h
> 
> diff --git a/drivers/pci/pcie/aer/Kconfig b/drivers/pci/pcie/aer/Kconfig
> index 50e94e0..c611384 100644
> --- a/drivers/pci/pcie/aer/Kconfig
> +++ b/drivers/pci/pcie/aer/Kconfig
> @@ -5,6 +5,7 @@
>  config PCIEAER
>  	boolean "Root Port Advanced Error Reporting support"
>  	depends on PCIEPORTBUS
> +	select RAS_TRACE
>  	default y
>  	help
>  	  This enables PCI Express Root Port Advanced Error Reporting

With this hunk changed to

Index: b/drivers/pci/pcie/aer/Kconfig
===================================================================
--- a/drivers/pci/pcie/aer/Kconfig      2014-06-11 17:33:57.298417802 +0200
+++ b/drivers/pci/pcie/aer/Kconfig      2014-06-11 17:34:16.302417487 +0200
@@ -5,6 +5,7 @@
 config PCIEAER
        boolean "Root Port Advanced Error Reporting support"
        depends on PCIEPORTBUS
+       select RAS
        default y
        help
          This enables PCI Express Root Port Advanced Error Reporting
--

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
