Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbbAPRVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:21:01 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:54284 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbAPRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:20:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>, Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Fri, 16 Jan 2015 18:20:32 +0100
Message-ID: <27357047.rXTtZ4bAbJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150116162944.EE0E3C40BF1@trevor.secretlab.ca>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <20150115182346.GE2329@e104818-lin.cambridge.arm.com> <20150116162944.EE0E3C40BF1@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:DQfu1JeztvCVC+EjVTCOIX5yMKqKdBHCw1yXV7/GBE7atkLsRNF
 FWeX3PFmKWuERbJjDy9QIFT1XY8YiCOK4rdJ0ux4LJPAIOj4zQpt1P34qtYw353ij6UjK5h
 c2UgBj+oU8siCWGwv63TWxhLpqr6bYKQ0urFV9JUpY7oo769/fRM6RAG2yTKRYj2QYBH2jK
 irK7/3Ono5894mqHPTrQA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 16:29:44 Grant Likely wrote:
> > > Instead, keeping these patches out means that hardware is getting
> > > developed and tested against Fedora, early access RHEL and Linaro
> > > kernels. It means that we're abdicating on any influence mainline has
> > > over how those platforms are developed. The longer these patches stay
> > > out of mainline, the greater the potential for delta between what is
> > > in the vendor kernels and what we accept into mainline.
> > 
> > I'm not buying this argument. Putting pressure on maintainers to merge
> > something because Fedora or some other distro has merged them is not the
> > right approach. If such Linux vendors ignore arguments on the list just
> > for the sake of providing ACPI support, there is a high chance that they
> > will accept non-standard code any other time when the kernel community
> > disagrees.

Actually there is strong precedence for merging things because distros
felt it was necessary. That's how we ended up with drivers/staging
in the first place.

It's not the nicest way to merge stuff, but it's something we cannot
ignore. Unfortunately it seems we already have the nonstandard code,
as Fedora includes the APM Mustang support that in previous reviews
we have concluded would not be suitable for upstream because it (in
particular the PCI support) is too far from SBSA.

> > > 4. Set clear expectations for those providing ACPI for use with Linux
> > >    * We have a document that covers what we know so far, and will
> > > continue to expand it. Also talking with the SBBR folks to move
> > > relevant requirements into the SBBR doc.
> > 
> > Moving bits of it into SBBR is a good long term plan but it should not
> > prevent the merging. However, I'd like to see more vendors ok'ing the
> > kernel document.

Agreed.

> > > 5. Platform support patches need verification and review
> > >    * ACPI core works on at least the Foundation model, Juno, APM
> > > Mustang, and AMD Seattle
> > >    * There still are driver patches being discussed. See Al's summary
> > > for details
> > >    * As I argued above, the state of driver patches isn't going to be
> > 
> > We are still lacking here. To quote Al, "First version for AMD Seattle
> > has been posted to the public linaro-acpi mailing list for initial
> > review". Sorry but I don't follow linaro-acpi list. I don't know what's
> > in those patches and I can't tell which subsystems they touch, whether
> > maintainers agree with them. So in conclusion, I'm not confident the
> > arm64 hardware ACPI story looks that great yet.
> > 
> > As for Juno and foundation models, I don't consider them server
> > platforms.

I did a large part of the review. I raised some important concerns about
the Seattle port, and addressing those will result in incompatible
changes, but I did not see any show-stoppers there.

To summarize, the main concerns were:

- AMD specific bindings for generic devices (ARM pl061, pl022, ...)
- network driver using _DSD with a binding that is incompatible with
  the existing DT binding. I believe this one was getting addressed,
  but I have not seen an update.

> > > 6. How does the kernel handle_DSD usage?
> > > While important, these issues are separate from whether or not to
> > > merge the core aarch64 code. This work was defined and driven by Intel
> > > for their embedded platforms, and it is already in mainline. Keeping
> > > aarch64 support out isn't going to prevent drivers using it from being
> > > merged. I don't think this should be a reason for blocking this
> > > series.
> > 
> > Intel folk is coming from the other direction, relatively standard
> > hardware getting slightly more non-standard and they need a few bits
> > added in _DSD. On ARM, we have completely non-standard hardware with DT
> > used to describe complex topology (clocks, pin controls, voltage
> > regulators etc.) with a high risk that vendors see _DSD as a work around
> > standardising hardware or doing it properly in ACPI (whatever that
> > means, AML?).
> 
> Doing it properly in ACPI merely means giving the drivers the data
> and/or methods that it needs. The ACPI spec does define some methods to
> be used by OSPM, but everything else is completely arbitrary, and always
> has been.
> 
> The *only* thing that _DSD does new is to define a specific format for
> adding key-value properties to an ACPI object that follow the rules of
> properties. Apple Mac hardware has done exactly the same thing for
> years, except it stuffed that stuff into the _DSM method.
> 
> So, _DSD is no less "doing it property in ACPI" than AML methods would
> be. In either case it is the responsibility of the driver to know what
> extra properties/methods might be attached to the device, and to know
> what to do with those properties/methods. The core OS doesn't care, and
> won't touch them.

What about PRP0001? Do we recommend against using it or should we try
to get everyone to use it for devices that already have a DT binding?

One result of the Seattle review was a patch to use class codes for
standard devices like AHCI. This is great and I think it's being merged
now, but we still have to figure out how to do this for standard
licensed IP blocks that don't already have a PCI class code, and whose
responsibility it should be to define a binding for such devices.

> > > 7. Why is ACPI required?
> > > I hope I've addressed this[1], but discussion continues.
> > > 
> > > [1] http://www.spinics.net/lists/arm-kernel/msg389955.html
> > 
> > That's great. I see this as a good reference for the future.
> > 
> > To complete the picture, we probably need a "Why *not* ACPI on ARM" blog
> > as well explaining when ACPI is *not* suitable (e.g. no SBSA
> > compliance). The arm-acpi.txt covers the ACPI requirements from the
> > kernel perspective and, by contrast, DT would be better suited for
> > certain platforms. The way you present it is that ACPI solves lots of
> > problems that DT doesn't but not necessarily where the ACPI limitations
> > are (vs DT).
> 
> I thought I was pretty clear in that document that ACPI is only
> preferred for the general purpose ecosystem (OS vendor and HW vendor are
> separate companies, and selected by the end user). Everywhere else the
> preference is DT. However, I can write more on this topic and make it
> clear that I'm talking about SBSA hardware. It will probably take me a
> week or so to get that written. Certainly before we're in Hong Kong for
> Connect.

I think it would be helpful for the purpose of merging the patches if
that statement can be stronger and say that DT is required for devices
other than SBSA hardware, rather than recommended. We can always relax
the rule later if there is a good reason, but it's hard to make it
stricter after the fact.

	Arnd
