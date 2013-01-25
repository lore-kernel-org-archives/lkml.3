Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3AYWAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:00:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:16022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab3AYWAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:00:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="276757471"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: Basic perf PMU support for Haswell v1
Date: Fri, 25 Jan 2013 14:00:33 -0800
Message-Id: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the "basic support"
as requested. 

I decided to include LBRs in the basic support. These are 4 patches
self contained at the end, so could be also handled as a separate
unit if that is preferable.

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters
- New TSX counter flags, exported as sysfs attributes
- Support for checkpointed counters.
- New LBR flags, exported as new flags with tools support

Available from 
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc hsw/pmu4-basics

For more details on the Haswell PMU please see the SDM. For more details on TSX
please see http://halobates.de/adding-lock-elision-to-linux.pdf

-Andi
