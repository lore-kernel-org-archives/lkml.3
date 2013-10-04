Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3JDLT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 07:19:26 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51630 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409Ab3JDLTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 07:19:24 -0400
Date: Fri, 4 Oct 2013 12:18:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Feng Kan <fkan@apm.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: Use of drivers/platform and matching include?
Message-ID: <20131004111820.GD25137@arm.com>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
 <CAOesGMjJ6Uj0uGFJqtnWQyDW+tr6eLVWoHZ+B7uFna+L8N6E8Q@mail.gmail.com>
 <20131003170914.GA11992@kroah.com>
 <CAOesGMhBaj14++kJ9tVko68MjC7D+JZrBRgoxa4zmZ9z186MQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhBaj14++kJ9tVko68MjC7D+JZrBRgoxa4zmZ9z186MQw@mail.gmail.com>
Thread-Topic: Use of drivers/platform and matching include?
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:54:07PM +0100, Olof Johansson wrote:
> On Thu, Oct 3, 2013 at 10:09 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Oct 03, 2013 at 09:46:30AM -0700, Olof Johansson wrote:
> >> I don't have a good answer though. If it wasn't for the arm64 fork,
> >> locating these under arch/arm somewhere would really be the reasonable
> >> answer, like we used to do on powerpc. :(
> >
> > Sounds like yet-another-good reason why there shouldn't be an arm64
> > "fork" at all :(
> 
> Doing a fork gives a chance at a clean slate refresh of platform
> support, which is in itself quite useful. But indeed it causes some
> things to be more complicated.

Also note that arm64 work started (internally) before the arm-soc was
formed and it was nearing upstreaming at a time when the arm-soc was
still undergoing heavy clean-up.

Of course, there is always a balance between advantages and
disadvantages but the main benefits are a clean implementation of
AArch64 architecture support (without legacy baggage) and forcing SoC
people to clean up the code for AArch64 (e.g. default single Image,
decoupling booting protocols from SoC initialisation, firmware interface
standardisation, resisting the urge to add SoC code under arch/arm64/).

> It's a common complaint that "everybody who ever forked for 64-bit
> have later merged", and that's true, but that doesn't mean there's no
> value in forking (and perhaps later merging), instead of adding on top
> to start with.

Exactly. Later merging is possible, but such process, to produce
clean/maintainable/shareable code, needs additional clean-up in the
32-bit ARM architecture code (at least breaking recent ARMv7 support
from legacy architectures). Otherwise we end up with either a less than
clean arm64 re-port on top of arm or just completely separate files
artificially forced under the same arch directory.

Where code sharing makes sense (e.g. ARM KVM and Xen), the arm64
Makefiles already reference arch/arm/. It's not ideal but it's a
trade-off for the time being.

> > The arm community created this mess, you all can fix it up, it's not too
> > late.
> 
> It wouldn't be a huge deal to add something like arch/arm/syslib and
> give some of the system library-type code a home there -- stuff like
> resource allocation libraries, etc. I don't think we want to collect
> all the back-end drivers in there though, just libraries.

On the SoC part, we need to analyse what exactly needs sharing, whether
it's a library used by multiple drivers (and arguably the library could
also go under drivers/) or whether it's some SoC initialisation that
could be better done before Linux is started.

-- 
Catalin
