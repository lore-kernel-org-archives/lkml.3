Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3GCOdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:33:24 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12940 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410Ab3GCOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:33:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18E+hDMWDJP3DZmnNDzoGd+crWvs63OIcY=
Date: Wed, 3 Jul 2013 10:33:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 5/7] ARM: kirkwood: remove redundant DT board files
Message-ID: <20130703143304.GI17110@titan.lakedaemon.net>
References: <1372762824-12202-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1372762824-12202-6-git-send-email-sebastian.hesselbarth@gmail.com>
 <87k3l8v9s1.fsf@natisbad.org>
 <51D40BA3.6000603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D40BA3.6000603@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 01:31:47PM +0200, Sebastian Hesselbarth wrote:
> On 07/03/13 01:09, Arnaud Ebalard wrote:
> >Hi Sebastian,
> >
> >Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> writes:
> >
> >>With DT support for mv643xx_eth board specific init for some boards now
> >>is unneccessary. Remove those board files, Kconfig entries, and
> >>corresponding entries in kirkwood_defconfig.
> >
> >Applying above your set an old quilt cleaning patch Jason asked at some
> >point, it became empty except for arch/arm/mach_kirkwood/common.h in
> >which some declarations were left behind. If this is correct, can you
> >just merge the hunks below in your 5/7 in next round?
> >
> >AFAICT, only dnskw_init() remains, which matches the list of board-*.c
> >files in arch/arm/mach_kirkwood/ (i.e. board-dt.c and board-dnskw.c).
> 
> While updating the patch with yours, I stumbled upon MACH_TS219_DT that
> also remains because it includes tsx1x-common.c.
> 
> I cannot recall if Jason or Andrew said something about removing it..

board-ts219.c can be removed as well.  It needed a check for running on
the 6282 variant in order to set the phy address properly.  This can now
be handled in kirkwood-ts219-628[12].dts.

thx,

Jason.
