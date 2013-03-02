Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3CBP7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:59:46 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40156 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3CBP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:59:44 -0500
Date: Sat, 2 Mar 2013 16:59:42 +0100
From: Andreas Mohr <andi@lisas.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130302155942.GA353@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> if ((revision == 0x13) && irq_remapping_enabled) {
> +		pr_warn("WARNING WARNING WARNING WARNING WARNING
> WARNING\n"
> +			"This system BIOS has enabled interrupt
> remapping\n"
> +			"on a chipset that contains an errata making
> that\n"
> +			"feature unstable.  Please reboot with
> nointremap\n"
> +			"added to the kernel command line and contact\n"
> +			"your BIOS vendor for an update");
> +	}

Forgive me, but ISTR that there's a special BIOS firmware quirk bug annotating
logger warning message mechanism (have I managed to hit all keywords yet? ;)
in the kernel which might be useful in this case.


OK, found something (but I don't think it was the mechanism
that ISTR - perhaps it got modernized?):


include/linux/printk.h:

/*
 * FW_BUG
 * Add this to a message where you are sure the firmware is buggy or
 * behaves
 * really stupid or out of spec. Be aware that the responsible BIOS
 * developer
 * should be able to fix this issue or at least get a concrete idea of
 * the
 * problem by reading your message without the need of looking at the
 * kernel
 * code.
 *
 * Use it for definite and high priority BIOS bugs.
 *
 * FW_WARN
 * Use it for not that clear (e.g. could the kernel messed up things
 * already?)
 * and medium priority BIOS bugs.
 *
 * FW_INFO
 * Use this one if you want to tell the user or vendor about something
 * suspicious, but generally harmless related to the firmware.
 *
 * Use it for information or very low priority BIOS bugs.
 */


So perhaps it is appropriate to be used here.


HTH,

Andreas Mohr
