Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3AaWwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:52:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:55890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab3AaWw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:52:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="250983858"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: Basic perf PMU support for Haswell v2
Date: Thu, 31 Jan 2013 14:51:38 -0800
Message-Id: <1359672710-19528-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the "basic support"
as requested.  I consider all of this basic support for Haswell usage.
although it's a bit more than what you need if you never use -e cpu//
or -b options.  I decided to include LBRs in the basic support. 

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters
- New TSX counter flags, exported as sysfs attributes
- Support for checkpointed counters.
- New LBR flags, exported as new flags with tools support

Available from 
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc hsw/pmu5-basics

For more details on the Haswell PMU please see the SDM (Vol 3A, Chapter 19.2)
http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html
For more details on TSX please see http://halobates.de/adding-lock-elision-to-linux.pdf
or next week's LWN.

v2: Addressed Stephane's feedback. See individual patches for details.

-Andi
