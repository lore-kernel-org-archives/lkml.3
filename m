Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3JIWWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:22:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59394 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab3JIWWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:22:53 -0400
Message-ID: <5255D6F5.3080000@zytor.com>
Date: Wed, 09 Oct 2013 15:21:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, monstr@monstr.eu,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@denx.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <1381250986.6062.3.camel@atx-linux-37> <20131008214221.GB11941@kroah.com> <CANk1AXS9fpypVVWgvvUCZjKXDvLPpB7=kCNucwFcktgBHmV37w@mail.gmail.com> <20131009014027.GA17066@kroah.com> <5254EC8A.8060609@monstr.eu> <20131009055332.GA4510@kroah.com> <52550638.2080301@monstr.eu> <52556585.3050603@zytor.com> <20131009192439.GC18611@kroah.com> <5255BE71.8010801@zytor.com> <20131009210715.GA17467@obsidianresearch.com>
In-Reply-To: <20131009210715.GA17467@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 02:07 PM, Jason Gunthorpe wrote:
> That is sort of backwards though, how does the driver know it should
> load and start fpga progamming?

A common way is for there to be a bitstream stored in flash which
presents an interface to download the data.  I think some FPGAs with
hard bus IP even has that built in.

Another variant -- common on USB -- is to use a simple USB interface
chip like an FTDI which can be used (sometimes in conjunction with a
CPLD) to (in effect) bitbang in a bitstream into the FPGA.  After
configuration, the programming pins are used for the USB interface.

	-hpa

