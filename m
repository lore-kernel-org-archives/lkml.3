Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3AWJPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:15:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38191 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3AWJPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:15:09 -0500
Message-ID: <1358932452.6252.169.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Revert "drivers/misc/ti-st: remove gpio handling"
From: Luciano Coelho <coelho@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jan 2013 11:14:12 +0200
In-Reply-To: <50FFA7F5.1000104@ti.com>
References: <1358766762-24405-1-git-send-email-coelho@ti.com>
	  <20130122201453.GR22517@atomide.com>
	 <1358890299.6252.166.camel@cumari.coelho.fi> <50FFA7A9.9040709@ti.com>
	 <50FFA7F5.1000104@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:05 +0100, Peter Ujfalusi wrote:
> On 01/23/2013 10:04 AM, Peter Ujfalusi wrote:
> > On 01/22/2013 10:31 PM, Luciano Coelho wrote:
> >> I thought about checking exactly what we need as delays and whether we
> >> really need to do all that toggling.  At least in some boards, the
> >> toggles are not needed, but I don't know for sure whether it works in
> >> all different variations of the chip, so I kept them to be safe.  Also,
> >> I tried to deviate as little as possible from a plain revert, since I'd
> >> like to get this into stable as well.
> > 
> > I can not find the documentation for the WiLink, but I would guess that it
> > needs some delay between high->low(off)->(wait)->high(on)->(power-on-time)->up

Yes, we probably need some kind of delay.  I'm not sure about the
low-high-low kind of thing though.  I'll try to figure it out.


> But mdelay() looks a bit overkill IMHO.

Yes, most likely we can use usleep or something.  I'll look into that as
part of my clean-up series. ;)

--
Luca.

