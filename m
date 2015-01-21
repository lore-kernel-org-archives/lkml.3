Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbAUJdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:33:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:53209 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbbAUJdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:33:40 -0500
Date: Wed, 21 Jan 2015 10:33:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 00/23] x86: Cleanup apic/ioapic/x2apic setup code
In-Reply-To: <54BF05CA.9070506@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501211031570.5526@nanos>
References: <20150115210458.625399149@linutronix.de> <54B8DBC1.6080205@linux.intel.com> <alpine.DEB.2.11.1501161120560.5526@nanos> <alpine.DEB.2.11.1501161203340.5526@nanos> <54BF05CA.9070506@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Jiang Liu wrote:
> On 2015/1/16 19:05, Thomas Gleixner wrote:
> Hi Thomas,
> 	With above patch applied, it just gives a blank screen
> instead of a panic when booting on my problematic laptop.
> Now I have found the root cause of the failure on my laptop.
> 	On i386, it triggers  BUG_ON(!apic->apic_id_registered())
> in function setup_local_APIC() because apic_bsp_up_setup() is called
> too late. So we need a simple patch as below. With following patch
> applied, it boots successfully with your original patch.

Duh. Right you are. I wonder why this boots on any other
machine. Seems there is some more magic in this setup maze.

Thanks,

	tglx
