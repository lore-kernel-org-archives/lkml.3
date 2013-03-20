Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3CTQdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:33:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:44474 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTQdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:33:44 -0400
Message-ID: <5149E4CE.2060104@infradead.org>
Date: Wed, 20 Mar 2013 09:33:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Michal Marek <mmarek@suse.cz>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
References: <s5h38vqjhk6.wl%tiwai@suse.de>
In-Reply-To: <s5h38vqjhk6.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/13 07:02, Takashi Iwai wrote:
> We encountered a problem that on some HP machines the Realtek PCI-e
> card reader device appears only when you inserted a card before the
> cold boot.  While debugging, it turned out that the device is actually
> handled via PCI-e hotplug in some level.  The device sends a presence
> change notification, and pciehp receives it, but it's ignored because
> of lack of the hotplug surprise (PCI_EXP_SLTCAP_HPS) capability bit.
> Once when this check passes, everything starts working -- the device
> appears upon plugging the card properly.
> 
> There are a few other bug reports indicating the similar problems
> (e.g. on recent Dell laptops), and I guess the culprit is same.
> 
> This patch adds a new module option, pciehp_surprise, to pciehp as a
> workaround.  When pciehp_surprise=1 is given, pciehp handles the
> presence change as the device on/off as if PCI_EXP_SLTCAP_HPS is set.
> Unless it's set explicitly, there is no impact on the existing
> behavior.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/pci/hotplug/pciehp.h      | 3 ++-
>  drivers/pci/hotplug/pciehp_core.c | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 

> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 7d72c5e..c3a574e 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
>  module_param(pciehp_poll_mode, bool, 0644);
>  module_param(pciehp_poll_time, int, 0644);
>  module_param(pciehp_force, bool, 0644);
> +module_param(pciehp_surprise, bool, 0644);
>  MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
>  MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
>  MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
>  MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if OSHP is missing");
> +MODULE_PARM_DESC(pciehp_surprise, "Force to set hotplug-surprise capability");


It appears that all of the pciehp options need to be documented,
preferably in Documentation/kernel-parameters.txt .


-- 
~Randy
