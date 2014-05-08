Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaEHO0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:26:31 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55488 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaEHO03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:26:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas =?ISO-8859-1?Q?Irest=E5l?= <andreas.irestal@axis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "abrodkin@synopsys.com" <abrodkin@synopsys.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>, "sr@denx.de" <sr@denx.de>,
        "jonas.jensen@gmail.com" <jonas.jensen@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>, peppe.cavallaro@st.com
Subject: Re: [RFC PATCH] net:Add basic DWC Ethernet QoS Driver
Date: Thu, 08 May 2014 16:26 +0200
Message-ID: <5261973.l3atPvULh6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <201405081618.04475.Andreas.Irestal@axis.com>
References: <201405081349.03139.Andreas.Irestal@axis.com> <20248221.mJ8pFfyc5U@wuerfel> <201405081618.04475.Andreas.Irestal@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:yhRajjbTMepDBHLzRddAuXHAuXtIJBz7Q0WV7/qsB+d
 XSi1v37NGk1JDEjWNZjdk4UbOtu20/6nPZKMOLZNygEIKdCo9S
 zD94BY1Cle57TSL8rBgIbxHK0dd1lYWAA/VLpDQua8JWBrHy0t
 fHf5B2iigNUz0xhNHub5KHq9WZG+WIOwsbXu+428+WDTiMvhV+
 yueF5MhqwF5ngtx8CyEYE5xiNlsK5HymY4tFwXuGecqZ4jpj+D
 6OjhcySba0vFHBkWdXjfGfo1CcBSRbn0V5QfClhEy6WcqtnirG
 57xXSeRoU368t7LL83Vmelk31GxOOk4Fjb9GtQ0XY2XoHpt3I1
 ZUSELpl4QPVYiuZkaZS4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 16:18:04 Andreas Irestål wrote:
> 
> > > +
> > > +   /* Set poll wait timeout to 2 seconds */
> > > +   dwc_wait = 200;
> > > +
> > > +   while (lp->tx_descs[i].tdes3.wr.own) {
> > > +           mdelay(10);
> > > +           if (!dwc_wait--)
> > > +                   break;
> > > +   }
> > 
> > This is really evil: you are blocking the CPU for up to two seconds!
> > You already mentioned that this is work-in-progress, but I guess it has
> > to be a little better than this and do something that doesn't block
> > out the CPU during TX.
> > 
> 
> It really is, but a 2s lockout is only happening upon TX failure. Anyway, this
> won't be an issue in the final version, since it won't use polling for TX.

Actually I'd expect a 10ms delay for most packets, which is also too much.

Just for scale: at gigabit speed, a 10 *microsecond* delay would be more
appropriate than a 10 milisecond delay. Anyway, it's not important here as
long as you find a proper solution.

	Arnd
