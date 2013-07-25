Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3GYPAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:00:42 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:15922 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3GYPAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:00:40 -0400
Message-ID: <1374764435.3058.4.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ming Lei <tom.leiming@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Oliver Neukum <oliver@neukum.org>,
        Grant Grundler <grundler@google.com>, Freddy Xin <freddy@asix.com.tw>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ASIX Louis =?UTF-8?Q?=5B=E8=98=87=E5=A8=81=E9=99=B8=5D?= 
	<louis@asix.com.tw>,
        "Allan Chou" <allan@asix.com.tw>
Date: Thu, 25 Jul 2013 16:00:35 +0100
In-Reply-To: <CACVXFVNre5SsJhaVqFNRcop7ahqxabWqHZkjBZccj1ZqOAUZ9A@mail.gmail.com>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	 <1374512879.4990.19.camel@edumazet-glaptop>
	 <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
	 <1374518312.1635.29.camel@bwh-desktop.uk.level5networks.com>
	 <1374518841.4990.26.camel@edumazet-glaptop>
	 <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
	 <1374559827.4990.143.camel@edumazet-glaptop>
	 <CACVXFVN0eN9E9efr8UdqFz68-emHa2o-RQ0RYfazEq8f=qxkLQ@mail.gmail.com>
	 <1374729058.23313.8.camel@edumazet-glaptop>
	 <CACVXFVNyFk0Zpi4tC0ENiq8RcrtrjYW-Dhs+A56+Pw4BKm8y8A@mail.gmail.com>
	 <1374750101.23313.16.camel@edumazet-glaptop>
	 <CACVXFVNre5SsJhaVqFNRcop7ahqxabWqHZkjBZccj1ZqOAUZ9A@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20036.004
X-TM-AS-Result: No--17.961000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 22:52 +0800, Ming Lei wrote:
[...]
> On Thu, Jul 25, 2013 at 9:34 PM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> >
> > Not that I have any experience with USB drivers, but perhaps
> > usb_sg_init()?
> 
> USB SG library doesn't support submitting SG URB asynchronously, but that isn't
> a big deal.  The problem is that many USB host controllers can't build
> one single
> packet from two buffers, what is why USB stack requires size of all
> buffers(except
> for last one) in sg list can be divided by max endpoint packet
> size.(1024 for usbnet)

Ugh.  Maybe the USB stack should allow drivers to find out about and
take advantage of a more flexible host controller.  Sounds like it could
be a big job, though.

Ben. (glad not to be using any USB net devices)

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

