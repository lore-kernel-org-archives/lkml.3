Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3BYKZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:25:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56334 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab3BYKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:25:31 -0500
Date: Mon, 25 Feb 2013 11:25:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>, Andreas Mohr <andi@lisas.de>,
        Alexander Lam <azl@andrew.cmu.edu>, bp@suse.de
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130225102526.GB12067@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>, Peter Feuerer <peter@piie.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Durgadoss R <durgadoss.r@intel.com>, Andreas Mohr <andi@lisas.de>,
	Alexander Lam <azl@andrew.cmu.edu>, bp@suse.de
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361762514.2303.21.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:21:54AM +0800, Zhang Rui wrote:
> the reason we keep on calling it because the thermal zone trip point
> info may be changed at runtime.
> 
> > Can we pass trip points and temperature levels upon registration time
> > instead?
> > 
> no, but we can cache it in the thermal layer, and do update when
> necessary.

Right, so this would make sense for fan, etc drivers which have static
trip points.

> why? I do not think the stepwise scheme will break it. If it happens, we
> should fix stepwise governor instead.

Ok, see my earlier mail for what acerhdf would need to be able to do.

> >  Therefore, add two more trip points - an
> > active one where we turn on the fan, and a critical one.
> > 
> I think you add a passive trip point and a critical one here.

I got 3 in total:

    if (trip == 0)
+           *type = THERMAL_TRIP_PASSIVE;
+   else if (trip == 1)
            *type = THERMAL_TRIP_ACTIVE;
+   else if (trip == 2)
+           *type = THERMAL_TRIP_CRITICAL;

> has anybody checked if the patch at lkml.org/lkml/2012/12/30/47 fixes
> the problem, without any other patch?

Ok, let me try it out.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
