Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab3E0EFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 00:05:12 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61525 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3E0EFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 00:05:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305262323.29519.arnd@arndb.de>
Date: Mon, 27 May 2013 12:23:02 +1000
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305262323.29519.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/05/2013, at 7:23 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 25 May 2013, Daniel Tang wrote:
>> Changes between v3 and v4:
>> * Remove redundant clock-names in device tree
>> * Re-enable bus access to some peripherals on bootup
>> * Clean up nspire-classic-timer code.
>>  - Implement a nspire_timer_set_mode function
>>  - Removed messy IO_MATCHx and CNTL_MATCHx macros
>>  - Timer starts disabled to begin with
>>  - Interrupt handling code return IRQ_NONE for spurious interrupts
>>  - Delete unnessecary shift
>> * Change clk-nspire to use compatible property to determine IO type
>> * Change device tree bindings to have appropriate vendor prefixes
>> * Added device tree binding documentation
>> * Fix incorrect register addresses for clocks
>> * Use more specific .caps for CLCD
> 
> Looks really good now. I have a few more comments for the first patch,
> mostly for stuff that can be simplified based on stuff we merged in 3.10.
> 
> The one remaining bit that sticks out is the clcd platform data. As I
> said before, I won't require you to convert that to DT in order to
> get your code merged, but I'd also really like to see that happen,
> as we will also need that to get rid of auxdata on the ARM reference
> platforms (integrator, versatile, realview, vexpress).

How would you like me to convert the platform data to DT? AFAIK, the clcd driver isn't aware of DT so the only way is to use the AUXDATA right now.

> 
> Are you motivated to look into those after the base patch gets
> merged into arm-soc?

Of course.

> 
> One comment on the merge path: While we can put any of the patches
> into the arm-soc tree, my preference is definitely for the clk,
> clksource, irqchip and input drivers to go through the respective
> maintainer trees. There are no dependencies to worry about, since
> each patch can compile standalone, and we just need to make sure
> they all get into 3.11 for your platform to work.

Yeah that's totally fine.

> 
> 	Arnd

Cheers,
Daniel Tang