Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaDNSKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:10:03 -0400
Received: from haybaler.sackheads.org ([140.186.190.103]:64026 "EHLO
	haybaler.sackheads.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDNSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:10:00 -0400
X-Greylist: delayed 1812 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 14:10:00 EDT
Date: Mon, 14 Apr 2014 13:39:48 -0400
From: Jimmie Mayfield <jimmie@sackheads.org>
To: linux-kernel@vger.kernel.org
Subject: Basic questions regarding del_timer_sync() and re-registering
	timers
Message-ID: <20140414173947.GA25057@sackheads.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi.  The common wisdom when mixing del_timer_sync() with timer functions
that re-register themselves is that the caller must ensure that re-registration
does not happen.

>From timer.c:
 * Synchronization rules: Callers must prevent restarting of the timer,
 * otherwise this function is meaningless.

I'm curious if someone could briefly explain why?

The pseudo-code for del_timer_sync and try_to_del_timer_sync looks 
something like this (ignoring the lock manipulation):

while (1) {
	if (timer is not running) {
		if timer is pending then detach it
		break
	}
	else {
		sleep
	}
}

So that the loop continues to spin until the timer function is no longer 
running at which point the kernel checks the pending list and removes it if 
necessary.

Q:  So given this construct, why is it imperative that the timer 
    function not re-register itself?  

I could understand that restriction if the timer function might be running on 
another CPU when the "if timer is pending then detach" step is executed but 
it's not obvious to me how that's possible since base->lock is owned at 
that point (not shown in the pseudocode)?

Can someone briefly point out what I've missed?


(while I am subscribed to LKML, please cc: me on replies so that they don't
get lost in the noise)

JM

-- 
Jimmie Mayfield  

