Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaKKADu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:03:50 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27474 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaKKADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:03:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8yc2nLlUtVIyBtGMYkLd9
Date: Mon, 10 Nov 2014 16:03:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: Nishanth Menon <nm@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH] ARM: OMAP4+: PM: Program CPU logic power state
Message-ID: <20141111000305.GJ31454@atomide.com>
References: <1413923076-26063-1-git-send-email-nm@ti.com>
 <7h61f98hvw.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7h61f98hvw.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@kernel.org> [141024 11:04]:
> Nishanth Menon <nm@ti.com> writes:
> 
> > CPU logic power state is never programmed in either the initialization
> > or the suspend/resume logic, instead, we depend on mpuss to program this
> > properly. However, this leaves CPU logic power state indeterminate and
> > most probably in reset configuration (If bootloader or other similar
> > software have'nt monkeyed with the register). This can make powerstate=
> > RET be either programmed for CSWR (logic=ret) or OSWR(logic = OFF) and
> > in OSWR, there can be context loss when the code does not expect it.
> >
> > To prevent all these confusions, just support clearly ON, INA, CSWR,
> > OFF which is the intent of the existing code by explicitly programming
> > logic state.
> >
> > NOTE: since this is a hot path (using in cpuidle), the exit path just
> > programs powerstate (logic state is immaterial when powerstate is ON).
> >
> > Without doing this, we end up with lockups when CPUs enter OSWR and
> > multiple blocks loose context, when we expect them to hit CSWR.
> >
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>

Applying into omap-for-v3.19/soc thanks.

Tony
