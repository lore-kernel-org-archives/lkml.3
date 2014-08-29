Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaH2Txc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:53:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37925 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753104AbaH2Txb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:53:31 -0400
Message-Id: <20140829195328.511550688@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Aug 2014 14:53:28 -0500
From: Mike Travis <travis@sgi.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: akpm@linux-foundation.org, msalter@redhat.com, dyoung@redhat.com,
        riel@redhat.com, peterz@infradead.org, mgorman@suse.de,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] x86: Speed up ioremap operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have a large university system in the UK that is experiencing
very long delays modprobing the driver for a specific I/O device.
The delay is from 8-10 minutes per device and there are 31 devices
in the system.  This 4 to 5 hour delay in starting up those I/O
devices is very much a burden on the customer.

There are two causes for requiring a restart/reload of the drivers.
First is periodic preventive maintenance (PM) and the second is if
any of the devices experience a fatal error.  Both of these trigger
this excessively long delay in bringing the system back up to full
capability.

The problem was tracked down to a very slow IOREMAP operation and
the excessively long ioresource lookup to insure that the user is
not attempting to ioremap RAM.  These patches provide a speed up
to that function.

-- 
