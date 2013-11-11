Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3KKRiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:38:25 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56539 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3KKRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:38:17 -0500
Date: Mon, 11 Nov 2013 09:13:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tony.luck@intel.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Does Itanium permit speculative stores?
Message-ID: <20131111171307.GA27002@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111117-1344-0000-0000-0000032B0865
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony,

Does Itanium permit speculative stores?  For example, on Itanium what are
the permitted outcomes of the following litmus test, where both x and y
are initially zero?

	CPU 0				CPU 1

	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
	if (r1)				if (r2)
		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;

In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
given this litmus test?

							Thanx, Paul

