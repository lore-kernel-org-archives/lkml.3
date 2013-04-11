Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab3DKNGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:06:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3DKNGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:06:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv2 arm: initial TI-Nspire support]
Date: Thu, 11 Apr 2013 15:06:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux@arm.linux.org.uk, Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com> <201304111430.05528.arnd@arndb.de> <C576ECFF-EF90-4995-AD28-1CEEE660DBAB@gmail.com>
In-Reply-To: <C576ECFF-EF90-4995-AD28-1CEEE660DBAB@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111506.34229.arnd@arndb.de>
X-Provags-ID: V02:K0:yxC40B7d3kS/7DLpo+QUONIW+m5ANWxYziAad4plI81
 U+eng77qfwQFrx3piakCgyhxpN0p+NvBY4BB8vJbt3owgcyYAa
 5Ef5918MDUV2Gk9om6m+Y2qysrWNeciyBDK0Du9LFluI7EGofv
 hl65ufYnoSrkoUTw/XLj2ujGXMTuaxLIY4RL1P1dvIazRdzKQP
 1153Pr8Xgqb5lOrC8sOQCZ/Xi1OBWDBptfzPDyMKHMLuzwmZfg
 saYwAMD/U82KPUpD/I02mM0b5690y1Fco5BFe9JdyMEDQwFpTb
 sYo60M/ed1IpDT3uZQo0h36IgvD8pbnz9NDQjFR0CXUsbBPGMK
 rd39m4rCUiZqQVdpy5VU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Daniel Tang wrote:
> >> +
> >> +CLOCKSOURCE_OF_DECLARE(nspire_classic_timer,
> >> +            DT_COMPAT, nspire_classic_timer_init)
> > 
> > Why do you need the logic to prevent it from being initilized
> > twice?  Can't you just remove the direct call to nspire_classic_timer_init
> > from platform code and rely on of_clk_init() to call it?
> > 
> 
> Ah, I wasn't aware that of_clk_init() would call the init functions. I thought it was up to clocksource_of_init() to do that.
> 
> Originally, I was adding a call to clocksource_of_init() to the platform code but
> that resulted in the timers being added twice. If of_clk_init() already calls the
> init functions, that would explain it. 

Sorry, I was confusing the calls, I meant clocksource_of_init() not of_clk_init().

I think the reason why they were added twice is that you have two nodes
matching "nspire-classic-timer", so you get called for each one, but the
existing code (pre linux-next) does not actually pass the node and you
end up looping through both for each of the two calls.

	Arnd
