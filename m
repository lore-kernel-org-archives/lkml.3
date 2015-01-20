Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbbATQI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:08:27 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47545 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbbATQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:08:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rvZPDcQ4MSsBm3k6syvbv
Date: Tue, 20 Jan 2015 08:04:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, linux-omap@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.19-rc2 v15 5/8] arm: omap1: Migrate debug_ll macros to
 use 8250.S
Message-ID: <20150120160448.GC7718@atomide.com>
References: <1420461624-4410-1-git-send-email-daniel.thompson@linaro.org>
 <1420461624-4410-6-git-send-email-daniel.thompson@linaro.org>
 <20150119213845.GL18552@atomide.com>
 <54BE1921.5050902@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE1921.5050902@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Thompson <daniel.thompson@linaro.org> [150120 01:03]:
> On 19/01/15 21:38, Tony Lindgren wrote:
> > * Daniel Thompson <daniel.thompson@linaro.org> [150105 04:49]:
> >> The omap1's debug-macro.S is similar to the generic 8250 code. Compared to
> >> the 8520 code the omap1 macro automatically determines what UART to use
> >> based on breadcrumbs left by the bootloader and automatically copes with
> >> the eccentric register layout on OMAP7XX.
> >>
> >> This patch drops both these features and relies instead on the generic
> >> 8250 macros:
> >>
> >> 1. Dropping support for the bootloader breadcrumbs is identical to the
> >>    way the migration was handled for OMAP2 (see 808b7e07464d...).
> >>
> >> 2. Support for OMAP7XX still exists but it must be configured by hand
> >>    (DEBUG_OMAP7XXUART1/2/3) rather than handled at runtime.
> >>
> >> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> >> Cc: Russell King <linux@arm.linux.org.uk>
> >> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> >> Cc: linux-omap@vger.kernel.org
> >> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> >> Acked-by: Tony Lindgren <tony@atomide.com>
> > 
> > Daniel, I suggest you upload this patch into Russell's patch tracking
> > system to get it merged. That at least shrinks down your patch series
> > if the other patches need more work.
> 
> This has been in the patch tracker for a week or so:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8271/1

OK good to hear thanks.
 
> I'm very aware that this patch (and indeed the whole patch set) has been
> knocking round for longer than it should have. The changelog for this
> patchset is certainly not one to be especially proud off ;-) .

Yeah, it's been floating around for a while :)

Here it may have been doable to first add the Kconfig entries, then
flip them on and remove the related .S file in a follow up patch. Not
sure if that would have helped to remove the dependencies for the
rest of the series though.

Regards,

Tony
