Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3IXWzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:55:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60556 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab3IXWze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:55:34 -0400
Message-ID: <52421829.4050708@zytor.com>
Date: Tue, 24 Sep 2013 15:54:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <20130919100833.GC19346@amd.pavel.ucw.cz>
In-Reply-To: <20130919100833.GC19346@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 03:08 AM, Pavel Machek wrote:
> 
>> The firmware approach is interesting.  It might be less flexible
>> compared with my original code (see link to git below) that this is
> 
> On the other hand... that's the interface world wants, right? To most
> users, fpga bitstream is just a firmware.
> 

No, not really.

The typical assumption with the firmware interface is that there is
exactly one possible firmware for each device (possibly modulated by
driver version, but still.)  This is blatantly not true for an FPGA in
the most extreme way possible -- there are an almost infinite number of
ways one can load an FPGA.

However, I have to question the whole idea of an "FPGA subsystem" --
there is an almost infinite number of ways to program an FPGA or FPGA
programming device (which may even be a commodity flash with a
microcontroller or CPLD, and may be shared with other devices), and it
really doesn't make any inherent sense to lump them together.

	-hpa

