Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaJ2Mtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:49:42 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:47854 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852AbaJ2Mtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:49:39 -0400
Date: Wed, 29 Oct 2014 13:46:29 +0100
From: Johan Hovold <johan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-ID: <20141029124629.GA8823@localhost>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
 <1414397368-26480-1-git-send-email-johan@kernel.org>
 <20141027154031.4492ea11d401045ca04a3ff8@linux-foundation.org>
 <20141028083633.GM2006@localhost>
 <20141028141805.7b67bba29734be326354957f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028141805.7b67bba29734be326354957f@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 02:18:05PM -0700, Andrew Morton wrote:
> On Tue, 28 Oct 2014 09:36:33 +0100 Johan Hovold <johan@kernel.org> wrote:
> 
> > > But it doesn't explain *why* we want the alarm to trigger before
> > > returning.
> > 
> > Should we really require every power-off handler to document arch
> > behaviour (even if its inconsistent and currently undocumented); in
> > this case that some arches return to user-space where we may oops if
> > called from process 0 (e.g. systemd, but not if using sysvinit)?
> 
> The kernel really doesn't have a problem related to excessive amounts
> of useful code comments :(
> 
> The bottom line is: did I provide a reader with the ability to
> understand why the code is this way?  If "no" then improvements beckon.
> 
> This does look like one code site where an elaborate explanation is
> warranted.  There's no way in which a reader can get to your above
> paragraph from the current rtc-omap.c.

I agree with you that I should add a comment on why that mdelay is
there to make it perfectly clear and obvious that it's purpose is to let
the alarm trigger, which in turn causes the pmic to power off the
system.

It is a power-off handler, and any power-off handler should not return
until it has at least attempted to power off the system. In this case,
that mandates a two-second delay.

So far, so good. I don't agree with you that every power-off handler
should document what happens if it fails to power-off the system. That
is, to describe what arches will happily return to user space, and under
what conditions (e.g. what init system is used) that this will cause a
panic.

If anything that belongs in arch code or kernel/reboot.c, and is
also something that is likely to change over time (consider the
power-off-handler call chains).

Johan
