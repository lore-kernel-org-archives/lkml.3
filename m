Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbbAVOyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:54:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41023 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbAVOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:54:03 -0500
Date: Thu, 22 Jan 2015 14:53:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
Message-ID: <20150122145331.GC12911@leverpostej>
References: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com>
 <20150119154357.GH21553@leverpostej>
 <54BD580C.6030701@gmail.com>
 <20150121165427.GA8722@leverpostej>
 <54BFDF2B.80708@caviumnetworks.com>
 <CAL_Jsq+Vtp=G6PJZvgksfLSXHBkoTC4TxLymP0ONk9MjaMtMPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+Vtp=G6PJZvgksfLSXHBkoTC4TxLymP0ONk9MjaMtMPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 02:19:55PM +0000, Rob Herring wrote:
> On Wed, Jan 21, 2015 at 11:17 AM, David Daney <ddaney@caviumnetworks.com> wrote:
> > On 01/21/2015 08:54 AM, Mark Rutland wrote:
> >>
> >> On Mon, Jan 19, 2015 at 07:16:28PM +0000, David Daney wrote:
> >
> > [...]
> >>>>>
> >>>>> @@ -67,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
> >>>>>         { .compatible = "ibm,476gtr-ahci", },
> >>>>>         { .compatible = "snps,dwc-ahci", },
> >>>>>         { .compatible = "hisilicon,hisi-ahci", },
> >>>>> +       { .compatible = "cavium,octeon-7130-ahci", },
> >>>>>         {},
> >>>>
> >>>>
> >>>> I was under the impression that the strings other than "generic-ahci"
> >>>> were only for compatibility with existing DTBs. Why do we need to add
> >>>> new platform-specific strings here?
> >>>
> >>>
> >>> Because it is an "existing DTB", The device tree doesn't contain the
> >>> compatible property of "generic-ahci", only "cavium,octeon-7130-ahci".
> >>
> >>
> >> While the DTB may already exist, the string "cavium,octeon-7130-ahci"
> >> isn't in mainline, and as far as I can see has never been supported.
> >
> >
> > There seems to be a disconnect here.  The DTB comes from the hardware boot
> > environment.  The hardware is in some cases already deployed.  It is for all
> > practical purposes, impossible to change the DTB.
> >
> > The idea that the kernel source code controls the content of the device tree
> > doesn't apply here.
> 
> I have to agree that adding the compatible string here is okay.
> Allowing/using generic names is the exception, not the rule. We're
> usually pushing the other way. People often complain about having to
> add a compatible string when they don't need it (yet).

If people are happy adding the string, then I have no problem with that.

My concern was with the "existing DTB" argument, which you've covered
below.

Thanks,
Mark.

> However, the argument that the privately developed DTB has to be
> accepted as is is complete crap. Maybe you have done a good job and
> have all straightforward bindings, so having them accepted won't be a
> big deal. We should be reasonable and not bikeshed things which are
> already in use and only affect a single device. Many of the bindings
> in vendor trees I have seen are a complete mess, but I expect better
> from you.
> 
> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
