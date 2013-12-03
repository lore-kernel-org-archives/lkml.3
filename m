Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3LCXml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:42:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:12114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab3LCXmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:42:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,820,1378882800"; 
   d="scan'208";a="418883060"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] x86: Add check for number of available vectors before
 CPU down
Thread-Topic: [PATCH] x86: Add check for number of available vectors before
 CPU down
Thread-Index: AQHO54G0xwYj7snyL0Gh1vo/GSQeoppDMV2Q
Date: Tue, 3 Dec 2013 23:42:19 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A59505E@ORSMSX106.amr.corp.intel.com>
References: <1384878243-5086-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1384878243-5086-1-git-send-email-prarit@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Prarit Bhargava [mailto:prarit@redhat.com]
> 
> Second try at this ...
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64791
> 
> When a cpu is downed on a system, the irqs on the cpu are assigned to
> other cpus.  It is possible, however, that when a cpu is downed there
> aren't enough free vectors on the remaining cpus to account for the
> vectors from the cpu that is being downed.
> 
> This results in an interesting "overflow" condition where irqs are
> "assigned" to a CPU but are not handled.
> 
> For example, when downing cpus on a 1-64 logical processor system:
> 
> +			if (per_cpu(vector_irq, cpu)[vector] < 0)
> +				count++;

But later on fixup_irqs will set some of vector_irq vector as -1 on this
to-be-disabled cpu. That will release vectors assigned to this cpu. So
checking vector_irq at this point before fixup_irqs doesn't make sense, right?

Thanks.

-Fenghua

