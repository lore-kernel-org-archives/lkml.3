Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaDHKWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:22:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:62465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaDHKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:22:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
Date: Tue, 08 Apr 2014 12:22:13 +0200
Message-ID: <4778371.oH3kIlbD0f@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140408095038.GT17163@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com> <20140408095038.GT17163@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W6AHNhBO0TPIYDCnYrEdkpLIdK49yhFkCN5Dg6I/VJu
 FdSQchjQICyGbg3XxF2JWRE3y1ThuxK8TuC6Ft6wVIDQ9oQfs6
 L+zxaN1I/Xraej1c0AU7n7h00sLfSN6qryA7JsxumWy3yaIwWD
 cmgVvAkUzLIS8/8vgpXn3GxMK037O1TXBRDGqrsUq/nGKuk2o5
 tPI8w4DxVDlaDjKghWRcgcaOzwxk44IJIFfzLAYR0P6jIy14rL
 J2ZjlSH+61A5EKZmeafI7JETl8Qi4OyIjcAUSn2ERkxlBB8X3t
 tzFTDETyAzPvLJOGkISIzLdVncI2f24IPqdJ3nSffYH8mMInBL
 TgKnyNWbX3tCWiI04l+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2014 10:50:39 Liviu Dudau wrote:
> On Mon, Apr 07, 2014 at 06:58:24PM +0100, Bjorn Helgaas wrote:
> > On Mon, Apr 7, 2014 at 5:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > I think migrating other architectures to use the same code should be
> > > a separate effort from adding a generic implementation that can be
> > > used by arm64. It's probably a good idea to have patches to convert
> > > arm32 and/or microblaze.
> > 
> > Let me reiterate that I am 100% in favor of replacing arch-specific
> > code with more generic implementations.
> > 
> > However, I am not 100% in favor of doing it as separate efforts
> > (although maybe I could be convinced).  The reasons I hesitate are
> > that (1) if only one architecture uses a new "generic" implementation,
> > we really don't know whether it is generic enough, (2) until I see the
> > patches to convert other architectures, I have to assume that I'm the
> > one who will write them, and (3) as soon as we add the code to
> > drivers/pci, it becomes partly my headache to maintain it, even if
> > only one arch benefits from it.

Fair enough.

My approach to the asm-generic infrastruction has mostly been to ensure
that whoever adds a new architecture has to make things easier for the
next person. For the PCI code it's clearly your call to pick whatever
works best for you.

> > Please don't think I'm questioning anyone's intent or good will.  It's
> > just that I understand the business pressures, and I know how hard it
> > can be to justify this sort of work to one's management, especially
> > after the immediate problem has been solved.
> 
> I understand your concern. I guess the only way to prove my good intentions
> is to shut up and show the code.

I'd suggest looking at architectures in this order then:

* microblaze (this one is easy and wants to share code with us)
* arm32-multiplatform (obviously interesting, but not as easy as microblaze)
* powerpc64 (they are keen on sharing, code is similar to what you have)
* mips (this is really platform specific, some want to share drivers with
  arm32, others should keep their current code. Note that platform selection
  on mips is compile-time only, they don't have to do it all the same way)
* powerpc32 (their code is currently different, might not be worth it)

My preference would be to have only the first two done initially and leave
the other ones up to architecture maintainers, but Bjorn should say
how much he wants to see get done.

	Arnd
