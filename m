Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbbAGSm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:42:26 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31108 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753603AbbAGSmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:42:23 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ziItV8Ff8BgSMtBJHW3eABywEWdtHPe8=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5275663FF71
Date: Wed, 7 Jan 2015 13:41:58 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150107184158.GO24989@titan.lakedaemon.net>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <2161376.07iV9ANMSk@wuerfel>
 <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
 <1520439.Y1rXzXY1eS@wuerfel>
 <20150107172741.GY2634@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107172741.GY2634@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 05:27:41PM +0000, Mark Brown wrote:
> On Wed, Jan 07, 2015 at 02:06:28PM +0100, Arnd Bergmann wrote:
> > On Wednesday 07 January 2015 11:50:39 Catalin Marinas wrote:
> 
> > > From what I gathered so far, the main reason for _some_ vendors is not
> > > support for "other" OS but actually features that ACPI has and DT
> > > doesn't (like AML; I deliberately ignore statements like "industry
> > > standard"). _If_ such reasons are sound, maybe they have a case for
> > > ACPI-only machines targeted primarily at Linux.
> 
> > What I got from the replies from HP, Huawei and from earlier discussions
> > with Jon is that they all hope to get to the point of relying on AML
> > alone to bridge the differences between SoC families. However, I don't
> > see that happening with the limited hardware compatibility that the
> > existing SBSA provides:
> 
> I tend to agree with you that it's an overreach to think that this is
> going to completely abstract away the differences between SoCs from
> different vendors without substantial further standardization work.
> However it does seem reasonable to expect that features like AML are
> going to be more successful in handling board differences and
> incremental revisions of SoCs - things like interactions with system
> power controllers for example.  That seems like a useful win in and of
> itself, and one that's worth supporting.

This piqued my interest, so I did a little research and found the
following to describe AML (second para under "What does this mean?")

  http://community.arm.com/groups/processors/blog/2014/05/01/let-s-talk-acpi-for-servers

iiuc, AML are basically drivers for some low-level functions provided as
binary blobs via the ACPI tables.  How does this work in a trusted boot
scenario?  Can the ACPI tables, and these binary blobs with it, be
updated from userspace?  If so, is there an authentication mechanism
(including for non-secure boot scenarios)?

One of the reasons I've really enjoyed working with ARM platforms and DT
is the absence of this type of 'feature'.  I honestly don't care whether
the kernel gets the board configuration info from DT or ACPI or FOO, as
long as we can avoid the security mistakes of the past:

  http://www.spiegel.de/international/world/catalog-reveals-nsa-has-back-doors-for-numerous-devices-a-940994.html

"""
... The ANT developers have a clear preference for planting their
malicious code in so-called BIOS, software located on a computer's
motherboard that is the first thing to load when a computer is turned
on.

This has a number of valuable advantages: an infected PC or server
appears to be functioning normally, so the infection remains invisible
to virus protection and other security programs. And even if the hard
drive of an infected computer has been completely erased and a new
operating system is installed, the ANT malware can continue to function
and ensures that new spyware can once again be loaded onto what is
presumed to be a clean computer. ...
"""

I'm not advocating "throw out AML and ACPI with it!", rather I'd like to
see a serious, open, discussion about the security implications of a
convenience feature such as AML.

And wrt the kernel, we should ensure we can always provide a fallback
for users who prefer not to trust the binary blobs.  Which shouldn't be
too difficult as we aren't dependent on AML or similar atm.

thx,

Jason.
