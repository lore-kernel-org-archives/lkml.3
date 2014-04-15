Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaDOSaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:30:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:59279 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaDOSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:30:23 -0400
Date: Tue, 15 Apr 2014 20:30:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH V1 Resend 2/5] tick-common: don't check tick_oneshot_mode_active()
 from tick_check_preferred()
In-Reply-To: <1af3a250749c7c103ef38b52d653559ac4ec899c.1397537987.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1404152028560.22697@ionos.tec.linutronix.de>
References: <cover.1397537986.git.viresh.kumar@linaro.org> <1af3a250749c7c103ef38b52d653559ac4ec899c.1397537987.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Viresh Kumar wrote:

> If 'curdev' passed to tick_check_preferred() is the current clock_event_device
> then these two checks look exactly same, because td->mode is set to
> TICKDEV_MODE_ONESHOT only when the event device has ONESHOT feature.
> 
> 	if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
> 		return false;
> 
> 	if (tick_oneshot_mode_active())
> 		return false;
> 
> Now left the case where 'curdev' is not the current clock_event_device. This can
> happen from the sequence started from clockevents_replace(). Here we are trying
> to find the best possible device that we should choose. And so even in this case
> we don't need the above check as we aren't really worried about the current
> device.

Wrong. If curdev is NULL, you might select a device w/o ONESHOT if the
system is in oneshot mode. Go figure.
 
Thanks,

	tglx
