Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797Ab3KLCik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:38:40 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47851 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3KLChT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:37:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] phy: Add MOXA RTL8201CP PHY support
To: Florian Fainelli <f.fainelli@gmail.com>,
        Jonas Jensen <jonas.jensen@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <CAGVrzcZW=CLWPZgRqkqR1wNh+S7dfwRZAzn1Uq7Ji6K0=iGYtg@mail.gmail.com>
References: <1383317673-14704-1-git-send-email-jonas.jensen@gmail.com> <CAGVrzcYfdChFNgkh=VAFZQfCRHyNTe_pZxx1Z6Sz1S8_1vzgtA@mail.gmail.com> <CACmBeS3aUq_yPVg_GaKmQRQMhAmO8RZVzUGY=T6Ghn7v0sP8Dw@mail.gmail.com> <CAGVrzcZW=CLWPZgRqkqR1wNh+S7dfwRZAzn1Uq7Ji6K0=iGYtg@mail.gmail.com>
Date: Mon, 11 Nov 2013 15:30:02 +0000
Message-Id: <20131111153002.722CCC4191F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013 09:51:24 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 2013/11/4 Jonas Jensen <jonas.jensen@gmail.com>:
> > This is why I ended up setting PHY_IGNORE_INTERRUPT and the comment
> > about its effectiveness. Polling works but the extra reads on the bus
> > seem unnecessary.
> > Ideas how they can be eliminated are appreciated.
> 
> As of today, the only way to work around it is not to use
> of_mdiobus_register() and use mdiobus_register() directly which will
> allow you to properly describe such a configuration.

of_mdiobus_register() can be changed. One option: If the caller knows
what it wants to happen in the case of no interrupt, then it can be
added as an argument to of_mdiobus_register(). No need to work around
this in an ugly way.

Is setting the irq to PHY_POLL something that should be done for the
entire bus, or only for a handful of PHYs?

g.
