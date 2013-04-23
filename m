Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3DWOLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:11:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:35016 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3DWOLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:11:05 -0400
Date: Tue, 23 Apr 2013 16:10:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Takashi Iwai <tiwai@suse.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: irq 16: nobody cared
In-Reply-To: <20130422213303.GB4415@pd.tnic>
Message-ID: <alpine.LFD.2.02.1304231524320.21884@ionos>
References: <20130420185330.GA4654@pd.tnic> <20130420235206.GA3509@linux.vnet.ibm.com> <20130421103403.GA4594@pd.tnic> <20130421163002.GB3509@linux.vnet.ibm.com> <s5hfvyj55ke.wl%tiwai@suse.de> <20130422091310.GA4637@pd.tnic> <s5hzjwq53ec.wl%tiwai@suse.de>
 <alpine.LFD.2.02.1304221432570.21884@ionos> <20130422142356.GA4658@pd.tnic> <20130422144402.GK3509@linux.vnet.ibm.com> <20130422213303.GB4415@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Borislav Petkov wrote:
> [ 1449.134864] ACPI: Preparing to enter system sleep state S5
> [ 1449.141054] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored

and right after that the spurious interrupt happens. I asked Boris to
boot with acpi_osi=Linux on the command line and the issue went
away, though now it complains right before shutdown about:

[  123.142377] do_IRQ: 2.179 No irq handler for vector (irq -1)

I wouldn't be surprised if that vector 179 was previously used for
irq16.

Without acpi_osi=Linux the BIOS manages to put the hardware into a
state which causes an interrupt to be sent from thin air.

We should have an annual "Brain Is Obviously Superfluous" award.
This one would be high up on the nomination list.

Yours grumpy

      tglx
