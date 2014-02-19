Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaBSClw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:41:52 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51769 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaBSClv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:41:51 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1J2fjba021473, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Florian Fainelli'" <f.fainelli@gmail.com>
CC: "'netdev'" <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>,
        "'linux-usb'" <linux-usb@vger.kernel.org>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com> <1392731351-25502-8-git-send-email-hayeswang@realtek.com> <201402190209.s1J29EVG032292@rtits1.realtek.com>
Subject: RE: [PATCH net-next 07/14] r8152: combine PHY reset with set_speed
Date: Wed, 19 Feb 2014 10:41:54 +0800
Message-ID: <3532474F0A1E449C8ABAC51A6F690258@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <201402190209.s1J29EVG032292@rtits1.realtek.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Thread-Index: Ac8tF5XvqtbfEJOuTIqKmAIOks/QnAAAyz4g
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Florian Fainelli [mailto:f.fainelli@gmail.com] 
> Sent: Wednesday, February 19, 2014 1:19 AM
> To: Hayes Wang
> Cc: netdev; nic_swsd@realtek.com; 
> linux-kernel@vger.kernel.org; linux-usb
> Subject: Re: [PATCH net-next 07/14] r8152: combine PHY reset 
> with set_speed
[...]
> > +static void rtl_phy_reset(struct r8152 *tp)
> > +{
> > +       u16 data;
> > +       int i;
> > +
> > +       clear_bit(PHY_RESET, &tp->flags);
> > +
> > +       data = r8152_mdio_read(tp, MII_BMCR);
> > +
> > +       /* don't reset again before the previous one complete */
> > +       if (data & BMCR_RESET)
> > +               return;
> > +
> > +       data |= BMCR_RESET;
> > +       r8152_mdio_write(tp, MII_BMCR, data);
> > +
> > +       for (i = 0; i < 50; i++) {
> > +               msleep(20);
> > +               if ((r8152_mdio_read(tp, MII_BMCR) & 
> BMCR_RESET) == 0)
> > +                       break;
> > +       }
> > +}
> 
> If you implemented libphy in the driver you would not have to
> duplicate that and you could use "phy_init_hw()" or
> genphy_soft_reset() to perform the BMCR-based software reset.

Thanks for you suggestion. I would study about those.
 
Best Regards,
Hayes


