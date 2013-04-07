Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3DGSK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 14:10:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49979 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151Ab3DGSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 14:10:25 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 7 Apr 2013 11:10:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Simon Glass <sjg@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
Message-ID: <20130407181028.GA28029@roeck-us.net>
References: <1360957573-864-1-git-send-email-dianders@chromium.org>
 <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <CAD=FV=UW4wGFqsg2B3MmC24jhnba5PSvCh8Wck-V6iuYk+Xifw@mail.gmail.com>
 <20130329115821.GC6359@the-dreams.de>
 <515F2E28.2090105@wwwdotorg.org>
 <20130406182957.GA11630@roeck-us.net>
 <20130406201132.GA3936@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406201132.GA3936@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 10:11:32PM +0200, Wolfram Sang wrote:
> Hi,
> 
> > Very interesting discussion, especially the argument that "we already shipped"
> > would not be a convincing argument.
> > 
> > I had senior kernel maintainers tell me and the company I work for that we should
> > submit _all_ our platform specific kernel code and drivers for inclusion into
> > the upstream kernel.
> 
> Yes, great. Really!
> 
Yes, though, thinking about it, it was "submit" and didn't say anything
about potential for acceptance.

> > This exchange suggests that "it is a shipping product" does not count for such
> > submissions, and that "Benefit for the kernel" would be the deciding factor
> > instead. Which of course is a very vague statement - if code supporting
> > Chromebookis is of no benefit for the kernel, support for my company's products
> > for sure is much less so.
> 
> First, let me state that I did not intend to say that the arbitrator
> muxer here has NO benefit for the kernel. I was aware there might be
> arguments for that and I wanted some more discussion to make that
> clearer to me. Simon's mail was very helpful in that regard and I will
> comment on that somewhen later.
> 
> Still, I do have problems with "we already shipped it". If the driver is
> bad or the underlying concept is fragile, I want the freedom to reject a
> patch, product shipped or not. I will be supportive to find a proper
> solution, promised. If all fails, there is still staging/ or the
> possibility of out-of-tree patches.
> 
I think there is a difference between a bad driver or underlying hardware. To
me, "shipped" applies to hardware or firmware which can not be upgraded, not to
the software running on it.

> > Which kind of leaves me in a bind. On one side I promote that we should submit
> > all our kernel code, on the other side there is a very compelling case to be
> > made that it won't be accepted anyway. That doesn't make my life easier -
> 
> Concentrate on argumenting why the driver is useful and it will be fine.
> "we already shipped this" feels a bit like blackmailing to me. And since
> most drivers do have well thought reasons for their existance, I'd
> primarily like to hear about those.
> 
> > essentially since it supports those who say that we should not submit anything
> > in the first place. And believe me, there are many of those. 
> > 
> > Just to give some examples:
> > - I2C multiplexers. We have a bunch of those. Looking at this exchange,
> >   it doesn't look good to get that code included.
> 
> Multiplexers should be easy going, it is the arbitration which is discussed here.
> I am open to consider some generic arbitration schemes. What I am reluctant to
> do is to allow every board to have its own arbitration scheme. This
> would be board support hosted in the I2C directory. Meh.
> 
"board support hosted in the I2C directory". But that is exactly what I am
talking about, isn't it ? I have board specific multiplexers and a board
specific I2C controller, and that is just talking about the I2C code.

> > It would be nice have to get some well defined guidelines for "acceptable"
> > contributions. "Benefit for the kernel" sure isn't one.
> 
> I don't think it is possible to write down concrete guidelines for this.
> "According to rule 4a) of the guidelines you have to accept my patch"?
> That would be a mess, I think.
> 
Looking at it from a maintainer perspective, I agree.

Where it gets murky is really the hardware part. The (in my opinion)
philosophical arguments around not permitting device-tree based instantiation
of uio devices is one example. Another practical example I had to deal with
in my previous company is VGA memory space. Some hw geniuses decided to re-use
the VGA memory space in an embedded x86 device for an EEPROM. Guess what -
the x86 kernel writes into that space no matter what. A patch to address that
problem was rejected because "you should not re-use VGA memory space".
As if I had a choice.

A better example might be Kontron board support. They implement gpio, I2C mux,
and a watchdog in a PLD. They too have an access arbitration scheme where
one has to acquire a hardware mutex before accessing the pld, if I understand
correctly because some microcontroller might need to access it as well.
Leaving the actual code aside, would you reject that too if you don't like
the arbitration scheme, or because you don't want to have board support
in the i2c directory ?

Thanks,
Guenter
