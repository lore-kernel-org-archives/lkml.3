Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009AbaH0TmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:42:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49873 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964833AbaH0TmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:42:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/aYUPh+G7NRyMvPmeMKm0R
Date: Wed, 27 Aug 2014 12:41:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH 07/10] ARM: OMAP5 / DRA7: Enable CPU RET on suspend
Message-ID: <20140827194156.GE16006@atomide.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
 <1408716154-26101-8-git-send-email-nm@ti.com>
 <7hbnr5dake.fsf@paris.lan>
 <53FE2BF2.3020006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FE2BF2.3020006@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140827 12:05]:
> On 08/27/2014 01:58 PM, Kevin Hilman wrote:
> > Nishanth Menon <nm@ti.com> writes:
> > 
> >> From: Rajendra Nayak <rnayak@ti.com>
> >>
> >> On OMAP5 / DRA7, prevent a CPU powerdomain OFF and resulting MPU OSWR
> >> and instead attempt a CPU RET and side effect, MPU RET in suspend.
> >>
> >> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> >> [nm@ti.com: update to do save_state only on DRA7]
> >> Signed-off-by: Nishanth Menon <nm@ti.com>
> >> ---
> >>  arch/arm/mach-omap2/omap-mpuss-lowpower.c |    4 ++++
> >>  arch/arm/mach-omap2/omap-wakeupgen.c      |    2 +-
> >>  arch/arm/mach-omap2/pm44xx.c              |    9 +++++++--
> >>  3 files changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> >> index 207fce2..0d640eb 100644
> >> --- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> >> +++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> >> @@ -242,6 +242,10 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
> >>  		save_state = 1;
> >>  		break;
> >>  	case PWRDM_POWER_RET:
> >> +		if (soc_is_omap54xx() || soc_is_dra7xx()) {
> > 
> > Aren't we trying to get away from these soc_* checks for anything other
> > than init code?
> 
> I would expect that to take place in stages as part of which the next
> level of cleanup is to move PRM into drivers. Currently our wakeupgen,
> prm code does have quiet a few needs of dealing with soc_is checks
> primarily from having to re-architect code in two different directions
> - we want to move into just one direction eventually - to prm drivers
> and as less code in mach-omap2 which is already in the works.

Why don't you just set some flag at init time based on the
soc_is check and then test that here? That limits the use of
soc_is to init code only which makes it easier to phase it
out completely eventually.

Regards,

Tony
