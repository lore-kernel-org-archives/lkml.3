Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3EGBfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:35:33 -0400
Received: from ozlabs.org ([203.10.76.45]:43437 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670Ab3EGBfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:35:30 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@google.com
cc: Linux PPC dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
X-GPG-Fingerprint: 9365 87D7 A7EF 4721 420B  91D9 CD5B 874B EAC1 B3F5
MIME-Version: 1.0
Subject: Invalid perf_branch_entry.to entries question
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 07 May 2013 11:35:28 +1000
Message-ID: <25394.1367890528@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter & Stephane,

We are plumbing the POWER8 Branch History Rolling Buffer (BHRB) into
struct perf_branch_entry.

Sometimes on POWER8 we may not be able to fill out the "to" address.  We
initially thought of just making this 0, but it's feasible that this
could be a valid address to branch to. 

The other logical value to indicate an invalid entry would be all 1s
which is not possible (on POWER at least).

Do you guys have a preference as to what we should use as an invalid
entry?  This would have some consequences for the userspace tool also.

The alternative would be to add a flag alongside mispred/predicted to
indicate the validity of the "to" address.

Mikey


