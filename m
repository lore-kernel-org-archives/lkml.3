Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab3LFTf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:35:26 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:10834
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab3LFTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:35:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zcb8kzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275ch1de098h1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386358508.7375.133.camel@snotra.buserror.net>
Subject: Re: [PATCH] watchdog: mpc8xxx_wdt: MPC8xx is HW enabled
From: Scott Wood <scottwood@freescale.com>
To: Wolfgang Denk <wd@denx.de>
CC: Guenter Roeck <linux@roeck-us.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Wim Van Sebroeck <wim@iguana.be>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>
Date: Fri, 6 Dec 2013 13:35:08 -0600
In-Reply-To: <20131202061418.05A11380BFE@gemini.denx.de>
References: <20131130154540.E83D743E15@localhost.localdomain>
	 <529B9152.9090106@roeck-us.net> <20131202061418.05A11380BFE@gemini.denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 07:14 +0100, Wolfgang Denk wrote:
> Dear Guenter,
> 
> In message <529B9152.9090106@roeck-us.net> you wrote:
> > On 11/30/2013 07:45 AM, Christophe Leroy wrote:
> > > MPC8xx watchdog is enabled at startup by HW.
> > > If the bootloader disables it, it cannot be reenabled.
> > 
> > Is that true for all variants of 8xx, especially for 823 ? I am a bit concerned
> > about breaking compatibility with some chips ... assuming there was a reason
> > for not setting this flag originally.
> 
> This is correct, and applies for all variants of the MPC8xx, including
> the MPC823 / MPC823E.  From the UM:
> 
> 	"The software watchdog timer can be disabled or its timeout
> 	period can be changed in the SYPCR. Once the SYPCR is written,
> 	it cannot be written again until a system reset."
> 
> Actually this is the only correct behaviour.  Any watchdog that can be
> disabled by software is not worth it's name, and unsuitable for any
> kind of aplications where security / reliability are required.

An optional locked state is a good thing, but making that the only way
the watchdog can function can render the watchdog unusable in systems
that need to go into low power states (unless the low power state
supresses the watchdog).  And then there's broken hybrid things like the
booke watchdog, where you can't disable the watchdog reset action once
configured, but you can change the timeout to be effectively infinite
(which we've used as a workaround when entering low power states).

-Scott



