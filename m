Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3CLLxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:53:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59261 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932912Ab3CLLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:53:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8vzYb9vkwBxhgxMsaTGt0XuG67HDz7wk=
Date: Tue, 12 Mar 2013 07:53:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-ID: <20130312115339.GF12700@titan.lakedaemon.net>
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
 <20130312062509.GQ21478@lunn.ch>
 <20130312111246.GD12700@titan.lakedaemon.net>
 <CAOesGMgSzn+uCVEMKZgtorcNkdzzvntmnfoej5vN-AjF43pnyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgSzn+uCVEMKZgtorcNkdzzvntmnfoej5vN-AjF43pnyQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:37:39AM -0700, Olof Johansson wrote:
> On Tue, Mar 12, 2013 at 4:12 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Tue, Mar 12, 2013 at 07:25:09AM +0100, Andrew Lunn wrote:
> >> On Tue, Mar 12, 2013 at 02:47:14PM +1100, Stephen Rothwell wrote:
> >> > Hi Andrew,
> >> >
> >> > Today's linux-next merge of the akpm tree got a conflict in
> >> > drivers/rtc/rtc-mv.c between commit 89c58c198b25 ("rtc: rtc-mv: Add
> >> > support for clk to avoid lockups") from the arm-soc tree and commit "rtc:
> >> > rtc-mv: use devm_rtc_device_register()" from the akpm tree.
> >> >
> >> > I fixed it up (I think - see below) and can carry the fix as necessary
> >> > (no action is required).
> >>
> >> Hi Stephan
> >>
> >> Looks O.K. to me.
> >>
> >> Acked-by: Andrew Lunn <andrew@lunn.ch>
> >
> > Same here,
> >
> > Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> We should make sure that future RTC changes get queued through AKPM
> and not through us to avoid these kind of conflicts. Same as other
> driver subsystems..

I agree, however, this patch is part of a four patch series fixing a
single problem reported by Simon Baatz:

  89c58c1 rtc: rtc-mv: Add support for clk to avoid lockups
  de88747 gpio: mvebu: Add clk support to prevent lockup
  7bf5b40 ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels
  93fff4c ARM: kirkwood: of_serial: fix clock gating by removing clock-frequency

Basically, if the user builds a kernel with most everything as modules
(eg copying the debian config), it will fail to boot.  All four fixes
are needed together to solve the problem.

I chose to keep them together to maintain bisectability.  Either you
have all of the fix (you landed on this branch), or you don't.  Was this
the correct decision in this case, or did I miss something?

Also, this series is CC'd to stable for inclusion in v3.8

thx,

Jason.
