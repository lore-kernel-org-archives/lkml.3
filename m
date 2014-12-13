Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaLMOdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 09:33:46 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50525 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaLMOdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 09:33:44 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/GvNHWIIeWZ0l/jvBPNCmxRvAh/ulcNlw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 802766305BB
Date: Sat, 13 Dec 2014 09:33:28 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] removing of some unused/unsupported dts entries
Message-ID: <20141213143328.GA967@titan.lakedaemon.net>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
 <8761dfgb1o.fsf@why.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761dfgb1o.fsf@why.wild-wind.fr.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silvio, Marc,

On Sat, Dec 13, 2014 at 09:21:23AM +0000, Marc Zyngier wrote:
> On Sat, Dec 13 2014 at  1:46:45 am GMT, Silvio Fricke <silvio.fricke@gmail.com> wrote:
> 
> Hi Silvio,
> 
> > I have found some dts entries which are not evaluated by the drivers. This
> > patch remove this entries from the dts files.
> > Jason has mentioned I should CC: Thomas, Marc and him self to this
> > mails.
> 
> As far as I can tell, this looks correct. A few key things though:
> 
> - Please write decent commit logs. Indicate *why* you think these
>   properties can be removed (hint: not finding corresponding in the
>   drivers is not enough a reason, the binding itself matters).

Right.  The real issue is the state of these properties within the
binding documentation.  Linux isn't the only consumer of these dts
files (*BSD, barebox, etc), so us not using them doesn't necessarily
mean the property should be removed.

The most important lesson (recently learned ;-) ) is to make sure all
properties are accurately describing the *hardware*.  Not Linux's
implementation of talking to the hardware.  That'll go a long way if the
changelog discusses how property X is an implementation detail vice a
hardware characteristic or feature.

> - Cc the relevant platform maintainers. You're changing things that they
>   care about, basic courtesy is to keep them in the loop.

True.  In Silvio's defense, I just told him to Cc us to get the ball
rolling.  (I tend to dislike long discussions on chat mediums, I'd much
rather they be in email.  So I was definitely too succinct).

For the record, you can use ./scripts/get_maintainer.pl on your patches
to make sure you get most of the right people.  In this case, that'll
include the DT maintainers.  You may want to run a get_maintainer.pl -f
arch/arm/mach-$ARCH for each of the dts file you touch.  Those
maintainers usually wrangle the patches for their dts files.
Unfortunately, not all of them have updated MAINTAINERS
(<cough>mvebu<cough>) to include the dts file patterns.

thx,

Jason.
