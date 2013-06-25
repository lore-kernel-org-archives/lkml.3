Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3FYNaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:30:09 -0400
Received: from mail.abilis.ch ([195.70.19.74]:23384 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3FYNaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:30:07 -0400
Date: Tue, 25 Jun 2013 15:29:25 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
Message-ID: <20130625132925.GC30827@ab42.lan>
References: <20130530211944.05F4D3E0A90@localhost>
 <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
 <alpine.LFD.2.02.1305311835040.2905@ionos>
 <20130531221814.534DF3E08FE@localhost>
 <51AC15FA.4060800@synopsys.com>
 <CACxGe6se9rqOdLAqj7XQ+Awa5HP+2k1t7pN1AYOAPdiL2o3AjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACxGe6se9rqOdLAqj7XQ+Awa5HP+2k1t7pN1AYOAPdiL2o3AjQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 10:51:06AM +0100, Grant Likely wrote:
> On Mon, Jun 3, 2013 at 5:05 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> > On 06/01/2013 03:48 AM, Grant Likely wrote:
> >> If I were working on this system I'd drop the
> >> snps,arc700-intc node entirely and have a single abilis,tb10x-intc that
> >> encapsulated the properties of both (you would of course want to share
> >> handler functions for the 'normal' inputs without the custom features).
> >> That would eliminate the goofyness of listing 27 separate interrupts in
> >> the abilis,tb10x-ictl interrupts property.
> >
> > But how is this different from other systems with a primary in-core intc and a
> > cascaded external intc. How do they do it. I guess I need to read up more on this.
> 
> Usually cascaded irq controllers have multiple irqs multiplexed onto a
> single irq on the parent controller. It's the 1:1 situation that makes
> this controller odd.

You're right, this might be a bit confusing. The controller was mainly
designed as a compatibility layer between ARC770 built-in interrupts and
the rest of the system.

Do you see a better way to drive this kind of hardware? Do you have any
other comments on the driver?

Without this driver, arch/arc/plat-tb10x and related drivers will not
work and it would thus be good to have this in the kernel as quickly as
possible if there are no more issues with it.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
