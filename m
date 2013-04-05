Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162123Ab3DEQla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:41:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:36493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162048Ab3DEQl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="289979643"
Date: Fri, 5 Apr 2013 18:41:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: rtsx_pcr, fix probe fail path
Message-ID: <20130405164123.GQ17363@zurbaran>
References: <1365104051-22872-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365104051-22872-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiry,

On Thu, Apr 04, 2013 at 09:34:11PM +0200, Jiri Slaby wrote:
> When rtsx_pci_acquire_irq fails in rtsx_pci_probe, we forget to
> disable an MSI (if we enabled it). This results in this warning on the
> next attempt to load the module:
> WARNING: at drivers/pci/msi.c:834 pci_enable_msi_block+0x2a4/0x2b0()
> Hardware name: HP EliteBook 840 G1
> Modules linked in: rtsx_pci(+) ...
> Pid: 4056, comm: modprobe Tainted: G          I  3.8.0-9405-gd895cb1-1-vanilla #1
> Call Trace:
>  [<ffffffff81045c6a>] warn_slowpath_common+0x7a/0xc0
>  [<ffffffff81045cc5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff81302544>] pci_enable_msi_block+0x2a4/0x2b0
>  [<ffffffffa05e335a>] rtsx_pci_probe+0x55a/0x720 [rtsx_pci]
> ...
> 
> So properly disable MSI in that case.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/mfd/rtsx_pcr.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
