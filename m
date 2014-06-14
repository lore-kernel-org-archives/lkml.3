Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaFNH2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:28:51 -0400
Received: from ns.horizon.com ([71.41.210.147]:39938 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751656AbaFNH2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:28:50 -0400
Date: 14 Jun 2014 03:28:49 -0400
Message-ID: <20140614072849.27887.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH-v2 4/4] random: clean up interrupt entropy accounting for archs w/o cycle counters
Cc: linux@horizon.com
In-Reply-To: <1402730118-23122-4-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	if (cycles || (fast_pool->notimer_count >= 32))
+		credit++;

Ah, this addresses my concern about too few interrupts, too.  If the
(non-timer) interrupt rate is less than 32/second, you'll never get any
credit.

(If you want to support this mode of operation and still have a non-zero
credit rate, move the clear of notimer_count into this condition.  Then
you get 1 bit per 32 non-timer interrupts no matter how slow.)
