Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaJCJpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:45:12 -0400
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:41347 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbaJCJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:45:10 -0400
Date: Fri, 3 Oct 2014 04:45:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
Message-ID: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct irq_desc still has

  unsigned int irq_count;


A timer interrupt occurs 1000 times per second and there are 86400 seconds
in a day. There is a counter for the local timer interrupt that needs to
be continually incremented.

So the counter will overflow in

2^32 / 1000 / 86400 = 46 days

Diagnostic tools will be surprised by the counters suddenly going back to
zero. There may be other interrupt sources that also occur quite often.

Is this the way its intended or should the counters be expanded to 64 bit?

64 bit would last for our lifetime.

