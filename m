Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaKGQr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:47:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48704 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbaKGQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:47:25 -0500
Date: Fri, 7 Nov 2014 16:47:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Alban <albeu@free.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH] OF: Add support for built in FDT blob
Message-ID: <20141107164701.GC5586@leverpostej>
References: <1415358849-25879-1-git-send-email-albeu@free.fr>
 <20141107120933.GA5487@leverpostej>
 <20141107135931.376caf98@tock>
 <CAL_Jsq+n8owZz6yas=surm4fTaGWgUuCLLEKXYKm8_02S8DdYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+n8owZz6yas=surm4fTaGWgUuCLLEKXYKm8_02S8DdYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 02:56:32PM +0000, Rob Herring wrote:
> On Fri, Nov 7, 2014 at 6:59 AM, Alban <albeu@free.fr> wrote:
> > On Fri, 7 Nov 2014 12:09:33 +0000
> > Mark Rutland <mark.rutland@arm.com> wrote:
> >
> >> Hi,
> >>
> >> On Fri, Nov 07, 2014 at 11:14:09AM +0000, Alban Bedel wrote:
> >> > Allow embedding an FDT blob in the kernel image, this is mostly
> >> > useful to run new kernels on boards with old bootloaders.
> >>
> >> I am very much not keen on embedding a DTB within a kernel. It's far
> >> nicer for the two to remain separate blobs, with a small shim to set
> >> up the DTB address.
> >>
> >> On ARM we have appended DTB for this purpose, which is at least better
> >> than embedding the DT inside of the kernel.
> >
> > I looked at that but that seemed quiet complicated to implement, not to
> > mention that it needed quiet a lot of arch specific code. On the other
> > hand having the DTB built in like this was trivial and would be portable
> > to every architecture, so that seemed like the best way to me.
> >
> >> What architecture and bootloader are you using that necessitate this?
> >
> > MIPS with an antic u-boot version patched by the board vendor to use
> > some non standard image format. Updating the boot loader is currently
> > not an option because of the lack of documentation for the board/SoC.
> 
> MIPS and a few other arches already have built-in dtb support. We
> don't need another way to do it, but I would welcome any clean-up that
> makes it arch independent and available to any arch.
> 
> While Mark is right, I could envision other uses such as embedding
> overlay dtbs in the kernel either for add-on boards or just as fixups.

I don't see how embedding a DTB in this manner helps with overlays and
fixups.

I'm rather worried about this turning into a shoddy board file, and
making it painful to build/distribute/boot a generic kernel for an
arbitrary platform.

On arm64 the kernel and DTB have always been separate, and I'm not keen
on allowing the two to be tightly coupled in this way. There are already
container formats (e.g. FIT) that can be used to hold both if that's
what the bootloader desires.

Thanks,
Mark.
