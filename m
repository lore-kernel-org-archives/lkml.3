Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaBQSqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:46:20 -0500
Received: from imap.thunk.org ([74.207.234.97]:59097 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbaBQSqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:46:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [REGRESSION v3.14-rc2] NULL dereference in icmp6_send()
Date: Mon, 17 Feb 2014 13:46:13 -0500
Message-ID: <nsxzjlp4lxm.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was sitting in the Admiral's Club of Boston Logan airport, having
connected to the free airport wifi, although I had not yet logged into
the captive portal, when I received the following BUG.   I've also seen
this once before when connected to my home network (running the CeroWRT
stable snapshot, versoin 3.7.5-2), although I wasn't able to get a
screen shot that time:

https://plus.google.com/photos/+TheodoreTso/albums/5981437894092747105/5981437896646076466

The transcribed stack dump is:

icmp6_send
ip6_expire_frag_queue
ip6_frag_expire
call_timer_fn
run_timer_softirq
irq_exit
...

I was running v3.13 and v3.13-rcX previously without seeing this, so I
suspect this is a regression.

Cheers,

                                                - Ted
