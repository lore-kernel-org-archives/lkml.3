Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3G0LLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 07:11:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38927 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3G0LLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 07:11:06 -0400
Date: Sat, 27 Jul 2013 12:09:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
	people interested in device tree janitoring / cleanup?]
Message-ID: <20130727110920.GE24642@n2100.arm.linux.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com> <20130727050406.GB4221@netboy> <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com> <51F3A238.3020505@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F3A238.3020505@broadcom.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 12:34:32PM +0200, Arend van Spriel wrote:
> Oh, and the reason for my tinkering on dts is here:
>
> http://mid.gmane.org/51E7AA24.6080600@broadcom.com
>
> Happily using Pandaboard for my driver testing and than *kaboom*.  
> board-omap4panda.c is gone although the device tree does not provide the  
> same functionality. Of course, this is not about DT bindings.

Similar happened to the 4430SDP board - and I took it out of the build
system for over a month because of that.  I knew it would be _painful_
to get DT and running on the board, and I was right, not only because of
the different build process, but also trying to find which kernel config
options need to be added to a previously working configuration for what
is essentially a black box board.

The MMC device for the rootfs magically changed too - which meant finding
out how to tell the kernel which device to use as the rootfs without
giving it an explicit device.  (Using UUIDs, which aren't real UUIDs and
aren't related to the filesystem UUID either - I've still no idea where
this magic number comes from or how to identify it from a running system.)

It's also made a total mess of the boot log.  I've no idea if all the
devices were successfully probed because there's now soo much noise from
the deferred probing that it's like trying to work out if there's any
serious warnings in a kernel build where every file spits out a warning.
It's almost a pen and paper job to work it out.  There's just too much
noise in the kernel boot now that I'm just not going to bother reading
the boot log anymore unless there's something which has noticably failed.

On the plus side, the DT description for the SDP board _may_ have helped
to solve a problem I've had for over two years: that is why the LCDs don't
seem to work on the board.  It seems I need the TWL PWM driver.  I don't
yet know if this has solved the problem or not, because I've not seen the
board boot with that driver in it.  However, it's not clear to me from the
DT description whether that covers both of the LCDs or just one though.
