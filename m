Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3IJPuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:50:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51733 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab3IJPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:50:18 -0400
Message-ID: <522F3E1D.30309@wwwdotorg.org>
Date: Tue, 10 Sep 2013 09:43:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>, Kevin Hilman <khilman@linaro.org>,
        ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/3] ARM: SoC: Second round of changes for v3.12
References: <1378766555-9679-1-git-send-email-khilman@linaro.org> <CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com> <1378825549.2627.316.camel@shinybook.infradead.org> <CA+55aFyRUZMJiotV0kAUoeEFpFdvK2r-3rXuS7NO4jHoQ+OkPA@mail.gmail.com>
In-Reply-To: <CA+55aFyRUZMJiotV0kAUoeEFpFdvK2r-3rXuS7NO4jHoQ+OkPA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 09:31 AM, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 8:05 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>>
>> In cost-sensitive products (and what *isn't* cost-sensitive these days),
>> you really don't want to have to put an extra EEPROM on the board
>> somewhere
> 
> Don't be silly. Nobody wants an extra chip. Especially not one that is
> programmable separately from the hardware. That way lies madness and
> the usual firmware crazies.
> 
> It's not even what I asked for. I talked about discoverable buses. How
> hard is that to understand? No extra chips, no eeprom, just a bus with
> a notion of configuration cycles. It doesn't even have to be as
> complicated as PCI, it could easily be a read-only model.
> 
> But no, every SoC designer out there seems to want to make their
> hardware crap. Don't be surprised when I then call them out on the
> fact. And don't bring up totally irrelevant issues that have nothing
> to do with anything.

(Many of) the buses aren't something that ARM SoC designers invented
though; they're industry standard things like I2C, SPI, I2S, all of
which are supported by SoC manufacturers solely because there are huge
numbers of useful chips that attach to these buses, from many many
manufacturers. This is an industry issue, not some evil conspiracy by
ARM SoC vendors.

True, it'd be lovely if those standard buses were discoverable; if the
industry had ended up with more advanced buses (although again: cost, to
implement those features, even if embedded into the chip itself rather
than as an external component).

Now, there are certainly cases where everybody just does their own silly
thing in HW, such as using GPIOs from a separate GPIO controller for SD
card detect and write-protect signals, rather than having the SDHCI
controller handle those functions, and hence be standalone. So from that
perspective your point is justified. However, solving this aspect would
only solve part of the problem.

x86 PCs likely have at least some of this exact same HW, e.g. I2C-based
LM90 thermal sensors. However, I /think/ this all gets hidden from the
OS by ACPI or other firmware mechanisms. Do you prefer firmware
abstraction over DT?
