Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaCDXpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:45:53 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51349 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755855AbaCDXpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:45:51 -0500
Date: Tue, 4 Mar 2014 23:45:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Joe Perches <joe@perches.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
Message-ID: <20140304234536.GA11418@arm.com>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
 <1393899715.20435.8.camel@joe-AO722>
 <53153A4C.9050602@infradead.org>
 <CACxGe6tD3mQshDSoEQaPXAnXG_siUdiFoAWhjmO2gDY7ZzkjUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tD3mQshDSoEQaPXAnXG_siUdiFoAWhjmO2gDY7ZzkjUw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:59:46AM +0000, Grant Likely wrote:
> On Tue, Mar 4, 2014 at 6:23 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Mar 04, 2014 at 02:15:45AM +0000, Graeme Gregory wrote:
> >> +ACPI ARM64
> >
> > That's a pretty broad statement for a single file. Is it core support,
> > architected peripherals, SoC?
> 
> That's a good point. Graeme, it would be good if you could put some
> text in the patch describing how you propose the maintainership to
> work. Unfortunately the maintainers file doesn't have any kind of
> comments field, otherwise I'd suggest you make those comments directly
> there.

I would actually go for something that can be used as a reference like
Documentation/arm64/acpi.txt. This will be a document that evolves in
time but pretty much sets the direction for what it means to support
ACPI on the arm64 kernel. Yesterday's talk at Linaro Connect about
clocks and voltage regulators on ACPI platforms is a clear example that
needs to be captured in a kernel document.

For DT we have documented bindings and I was too lazy for a broader
arm64 soc.txt document but I plan send an RFC across the lines of
https://plus.google.com/103785593327310749350/posts/dZF3zf7z2v4 (unless
the arm-soc guys beat me to it ;)).

I really don't see much point in an ACPI ARM64 maintainers entry that
only covers a 200 lines long file without guidelines on what else is
going into other parts of the kernel related to ARM ACPI.

> Given that ACPI can touch a lot of subsystems I would expect you and
> Hanjun not to be merging much code directly, but being listed in
> maintainers means that you will be kept in the loop when it comes to
> merging ARM ACPI changes. I would also expect that anything that does
> go through you (instead of merely acked) would be merged via Rafael
> and Len's tree.

No issues here.

> >> +M:   Hanjun Guo <hanjun.guo@linaro.org>
> >> +M:   Graeme Gregory <graeme.gregory@linaro.org>
> >> +S:   Supported
> >> +L:   linux-acpi@vger.kernel.org
> >> +F:   drivers/acpi/plat/arm-core.c
> >
> > This patch should be part of the series introducing the arm-core.c file
> > and it will be ACKed (or NAKed) following review. We can't really commit
> > maintainers to a file which does not exist in mainline and while there is
> > still feedback to be addressed. It's like a blank cheque.
> 
> I agree with merging it with the rest of the series, but comparing it
> to a blank cheque is not appropriate. Merely having an entry in
> MAINTAINERS doesn't immediately confer trust or ability to merge code,
> but it does tell people who to talk to when looking at ACPI on ARM.
> You can bet that neither Linus, Len or Rafael will merge ARM ACPI
> trees from them if you disagree. (And even if they did, you would
> yell, and Linus would revert it).

The point is that I don't have to follow all the developments closely
and feel the need to yell, so I have to rely on (trust) the newly
appointed maintainers to do the right thing. The recent example with me
asking Rafael to drop the GIC patch shouldn't have really happened. It's
not for Rafael to decide on how many acks to be on a patch before being
merged (absolutely no complaints to Rafael here) but rather for the
patch contributors to reach out to relevant kernel developers and ask
for review/ack before sending the patch upstream (especially when there
is an ongoing conversation).

As I already stated, I'm not bothered with the ACPI clean-up patches,
that's up to Rafael/Len to merge. But those involving the ARM IP like
GIC and timers need wider review before going upstream. For something of
such importance to us like ARM ACPI, I really feel uneasy about patches
going into mainline with just a Signed-off-by (hint: your ack adds
significant weight to a patch ;)). Who/how many acks, I leave it to the
ARM64 ACPI maintainers to figure out but it must be non-zero to be able
to build up trust over time.

And there is the wider issue of which platforms go for ACPI and which
stay with DT. Here the key agreement should come from the arm64 and
arm-soc maintainers and captured in a kernel document. That's a kernel
decision based on technical merits and *not* driven by "artificial"
distro policies (sorry jcm).

-- 
Catalin
