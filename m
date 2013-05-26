Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3EZVX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:23:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:23:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Sun, 26 May 2013 23:23:29 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
In-Reply-To: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305262323.29519.arnd@arndb.de>
X-Provags-ID: V02:K0:w1Fs+vfcN7FkrYcVKK+q9gEb2UioTZjPxQUn1MPs8iP
 KCbWPDPzEetqB4ODADCgiDd+vYgEMhWK6into4WaCA8XCpbQE/
 i7FSQrxEnrAZ9BlZN3+mTPucAQuDbIk3kDpRipzcp6SdZMjiGx
 LUREo8Fi9fYicn/svnopLlK/0RCLLdueFi84Q5E5CTo/PCgpTF
 IkRZOn7LTSoLmjLcWxo1yVx9+CLIyAV2MTmjCBtWeQeCq+O+GF
 2MhlJkptvv3olSF/OImOzPO78lH7+oy7JjfasAjjZhHNzj8N3j
 Y2pNpcSJBkoKYVKt24AZYANAftQ+3nlHRqwg8pyc5eQBpLkCLj
 eJwgRKb5rG4OOviUUnb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013, Daniel Tang wrote:
> Changes between v3 and v4:
> * Remove redundant clock-names in device tree
> * Re-enable bus access to some peripherals on bootup
> * Clean up nspire-classic-timer code.
>   - Implement a nspire_timer_set_mode function
>   - Removed messy IO_MATCHx and CNTL_MATCHx macros
>   - Timer starts disabled to begin with
>   - Interrupt handling code return IRQ_NONE for spurious interrupts
>   - Delete unnessecary shift
> * Change clk-nspire to use compatible property to determine IO type
> * Change device tree bindings to have appropriate vendor prefixes
> * Added device tree binding documentation
> * Fix incorrect register addresses for clocks
> * Use more specific .caps for CLCD

Looks really good now. I have a few more comments for the first patch,
mostly for stuff that can be simplified based on stuff we merged in 3.10.

The one remaining bit that sticks out is the clcd platform data. As I
said before, I won't require you to convert that to DT in order to
get your code merged, but I'd also really like to see that happen,
as we will also need that to get rid of auxdata on the ARM reference
platforms (integrator, versatile, realview, vexpress).

Are you motivated to look into those after the base patch gets
merged into arm-soc?

One comment on the merge path: While we can put any of the patches
into the arm-soc tree, my preference is definitely for the clk,
clksource, irqchip and input drivers to go through the respective
maintainer trees. There are no dependencies to worry about, since
each patch can compile standalone, and we just need to make sure
they all get into 3.11 for your platform to work.

	Arnd
