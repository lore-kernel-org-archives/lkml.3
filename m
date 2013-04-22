Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3DVJSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:18:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48819 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab3DVJSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:18:49 -0400
Date: Mon, 22 Apr 2013 11:18:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, tiwai@suse.de,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422091847.GB4637@pd.tnic>
References: <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
 <20130421203447.GE3509@linux.vnet.ibm.com>
 <20130421205139.GC5807@pd.tnic>
 <20130421214241.GA4593@pd.tnic>
 <20130421220015.GF3509@linux.vnet.ibm.com>
 <20130421221242.GB4593@pd.tnic>
 <20130422080136.GA7080@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130422080136.GA7080@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:01:36AM +0200, Ingo Molnar wrote:
> Hm, this really smells like a workaround: treating the symptom, not
> the cause.

Well, I just tested Takashi's add missing synchronize_irq() to the
suspend path of snd_hda_intel and it doesn't help.

So it could be an issue with this driver or only this hw/driver can
exacerbate RCU this much to trigger the spurious irq machinery.

> How can an increase in grace-periods break drivers and suspend? Do we
> understand exactly what happens there?

I'd rather look into Paul's direction here. :)

> If we do, can we fix that instead of tweaking the RCU timeouts?

Well, I was under the impression yesterday that we actually want
to switch to expedited grace periods for suspend/resume *anyway*,
regardless of drivers.

Paul?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
