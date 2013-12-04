Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab3LDTkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:40:07 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45657 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab3LDTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:40:01 -0500
Date: Wed, 4 Dec 2013 11:39:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Will CPU 0 be forever prohibited from NO_HZ_FULL status?
Message-ID: <20131204193957.GA2847@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120419-0928-0000-0000-0000041039A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic,

Just realized that I could further decrease RT latency of one of my "shut
up RCU on NO_HZ_FULL CPUs" patches if I relied on CPU 0 always having
a scheduling-clock tick unless the entire system is idle.  The trick
is that I could then rely on CPU 0 to detect RCU CPU stall warnings,
and remove the checking from the other CPUs.

Thoughts?

							Thanx, Paul

