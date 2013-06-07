Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3FGMsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:48:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3FGMsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:48:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] ethernet/arc/arc_emac - Add new driver
Date: Fri, 07 Jun 2013 14:48:16 +0200
Message-ID: <6204768.NxiQ5EdAsp@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5C8E99@DE02WEMBXB.internal.synopsys.com>
References: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com> <2468036.im0srnzmHT@wuerfel> <4881796E12491D4BB15146FE0209CE643F5C8E99@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OqlDBwuRd3jkZAv9GXedWUZbDl1vKCqtkIkqpCWZQAS
 zfEwE207ASPcJqjZpYjO341nVieQgQgsyQ/7ncvhVRBs9rnQfO
 KMaIzsx23KbR6jIw2NTDpV4p+GBkWDHBIXRxiknNQHhsdll40N
 1/NjTcnqu7JUBBMIzHmPozaZ6ScUs/viin468FxJvuaQlngnVt
 7lbtJR/nOFPmMnoLfN4lBbVD2rq5O6TJ6rWlh4iosvt4KcQz1M
 fJKl36FS5nEB69dh8yg9gWViqYevw0dTS4vcbipR5wo2tr9ln6
 dvaQ6ybDrKoA20SPwUNKdKzkBq6D8W2YifQLYSliUFHQo6TRgU
 BKZMXCMAS+X0yx781BjE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 12:37:24 Alexey Brodkin wrote:
> On 06/07/2013 04:13 PM, Arnd Bergmann wrote:
> >>> I wonder if it would be better to name the directory "synopsys" or
> >>> "designware" rather than "arc" now. Is there a chance that the same
> >>> controller is used on non-arc CPUs?
> >>
> >> The thing is - "arc_emac" is a custom ARC's (that was implemented before
> >> acquisition of ARC by Synopsys) IP (it's not an IC - just a part of CPU)
> >> Ethernet controller that only exists in some legacy FPGA boards we
> >> (ex-ARC and our customers) still use a lot in development process.
> >>
> >> Synopsys itself doesn't actively sell this device so there's no point in
> >> putting ARC EMAC into Synopsys folder.
> >>
> >> And indeed we don't expect this device to be used with non-ARC CPU's.
> 
> I'm wondering if my clarification above makes sense and I may leave this 
> driver in "ethernet/arc" or you still prefer it to be under 
> "ethernet/synopsys"?

Yes, I think if we don't expect any future Synopsys/Designware branded
devices to use this, using ethernet/arc is fine.

The main reason to still use a different name is so we will be able
to group it with other drivers for designware ethernet controllers.

The only one I'm currently aware of is drivers/net/ethernet/stmicro/stmmac/.
If we wanted to ahve a designware directory, we should probably move that
as well.

I'll leave it up to you (or Dave, if he has a strong opinion).

	Arnd
