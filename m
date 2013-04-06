Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765123Ab3DFSaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 14:30:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59163 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183Ab3DFSaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 14:30:16 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 6 Apr 2013 11:30:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Simon Glass <sjg@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
Message-ID: <20130406182957.GA11630@roeck-us.net>
References: <1360957573-864-1-git-send-email-dianders@chromium.org>
 <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <CAD=FV=UW4wGFqsg2B3MmC24jhnba5PSvCh8Wck-V6iuYk+Xifw@mail.gmail.com>
 <20130329115821.GC6359@the-dreams.de>
 <515F2E28.2090105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515F2E28.2090105@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 02:03:52PM -0600, Stephen Warren wrote:
> On 04/05/2013 01:37 PM, Simon Glass wrote:
> > HI Wolfram,
> > 
> > On Wed, Apr 3, 2013 at 12:19 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> >> Doug,
> >>
> >>> Separately from a discussion of the technical merits, I'd say that
> >>> this patch is needed because the Embedded Controller (EC) on the ARM
> >>> Chromebook shipped expecting to communicate with this scheme.  While
> >>
> >> Uhrm, with all respect, "we already shipped it" is not a convincing
> >> argument regarding inclusion. Benefit for the kernel is.
> 
> I'm not quite sure why that isn't a convincing argument.
> 
> The hardware has shipped. I don't know whether the EC microcode can be
> updated in the field; it seems risky to do so even if it's possible. So,
> it either gets supported or not; the HW/ucode isn't going to change I
> suspect.
> 
> Hence, it seems that the decision would be:
> 
> a) Disallow the implementation of the arbitration scheme in the kernel,
> and hence don't support this board in the kernel. (or at least some very
> core features of this board)
> 
> b) Allow the implementation of the arbitration scheme in the kernel, and
> hence make possible support this board in the kernel.
> 
> From that perspective, the benefit for the kernel question comes down
> to: do we see a benefit for the kernel to support this board? I can't
> see why that wouldn't be a benefit.
> 
> The only disadvantage would be having to carrying code to support that
> board. That same argument can be made for any board, and I think
> typically doesn't cause any issue. The code for this I2C mux seems
> pretty self-contained, so even if it was absolutely terrible (which I
> don't think it is), it still wouldn't cause any wide-spread issues, I think.

Very interesting discussion, especially the argument that "we already shipped"
would not be a convincing argument.

I had senior kernel maintainers tell me and the company I work for that we should
submit _all_ our platform specific kernel code and drivers for inclusion into
the upstream kernel.

This exchange suggests that "it is a shipping product" does not count for such
submissions, and that "Benefit for the kernel" would be the deciding factor
instead. Which of course is a very vague statement - if code supporting
Chromebookis is of no benefit for the kernel, support for my company's products
for sure is much less so.

Which kind of leaves me in a bind. On one side I promote that we should submit
all our kernel code, on the other side there is a very compelling case to be
made that it won't be accepted anyway. That doesn't make my life easier -
essentially since it supports those who say that we should not submit anything
in the first place. And believe me, there are many of those. 

Just to give some examples:
- I2C multiplexers. We have a bunch of those. Looking at this exchange,
  it doesn't look good to get that code included.
- Custom multi-function FPGAs and CPLDs, amongst others implementing I2C
  controllers, I2C muxes, GPIO access, Flash access, and other functions. Same
  as above.
- Devicetree support for UIO devices (mostly forwarding ASICs), including gpio
  bindings, interrupt bindings, and clock bindings. Looking at older exchanges,
  that doesn't look good either. And please dont expect me to implement hacks
  around a clean solution because any devicetree binding for UIO drivers
  "does not describe hardware but its use".

Now, I can understand that there may be technical or architectural issues
preventing one driver or another from being accepted. For example, I can
understand if a driver for an USB-I2C adapder isn't accepted because the adapter
reports itself to the USB subsystem as serial driver. But "Benefit for the
kernel" is vague enough to reject anything for no real reason other than
someone not liking it (or the submitter, or the company the submitter
works for, or the hardware architecture).

It would be nice have to get some well defined guidelines for "acceptable"
contributions. "Benefit for the kernel" sure isn't one.

Guenter
