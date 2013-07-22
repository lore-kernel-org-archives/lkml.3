Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab3GVSij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:38:39 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:38316 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3GVSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:38:37 -0400
Message-ID: <1374518312.1635.29.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Ben Hutchings <bhutchings@solarflare.com>
To: Grant Grundler <grundler@google.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Freddy Xin <freddy@asix.com.tw>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ASIX Louis =?UTF-8?Q?=5B=E8=98=87=E5=A8=81=E9=99=B8=5D?= 
	<louis@asix.com.tw>,
        "Allan Chou" <allan@asix.com.tw>
Date: Mon, 22 Jul 2013 19:38:32 +0100
In-Reply-To: <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	 <1374512879.4990.19.camel@edumazet-glaptop>
	 <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20030.005
X-TM-AS-Result: No--16.352300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 11:29 -0700, Grant Grundler wrote:
> On Mon, Jul 22, 2013 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> ...
> > I guess that if a driver does not advertise NETIF_F_SG, this
> > skb_linearize() call is not needed : All frames reaching your xmit
> > function should already be linear
> 
> As Ben Hutchings pointed out, hw_features is still setting this...but
> I'm not sure how that matters.
> 
> ax88179_set_features() doesn't allow setting SG or TSO features.  But
> I expect it would be "not too difficult" to add such that ethtool
> could set those features after boot.
[...]

It already can.  That's what putting feature flags in hw_features does.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

