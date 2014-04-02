Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473AbaDBV6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:58:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:55928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030460AbaDBV6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:58:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,782,1389772800"; 
   d="scan'208";a="513212264"
From: "Brown, Len" <len.brown@intel.com>
To: "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Thread-Topic: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Thread-Index: AQHPTdaFVLQYzxSM7EqDlaR4cHXJtZr9TPjAgAHpVACAAAhvgP//n59w
Date: Wed, 2 Apr 2014 21:58:42 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C948452FDABF@FMSMSX106.amr.corp.intel.com>
References: <533B0288.2020304@windriver.com>
 <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
 <533C6C90.3000708@windriver.com> <20140402203130.GA22525@windriver.com>
In-Reply-To: <20140402203130.GA22525@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [    0.840668] intel_idle: lapic_timer_reliable_states 0x2
vs.
> [    0.877528] intel_idle: lapic_timer_reliable_states 0xffffffff

This means CPUID.ARAT is set for the new board, and not set
for the old board.  You can observe that also in /proc/cpuinfo flags
where you will likely also find a visible stepping difference between
these two boards.

Bring-up Avoton had ARAT disabled, and also had broken deep C-states.
It looks like that is what your old board has.  Throw it away and
use only production steppings.  If you are stuck w/ pre-production hardware,
then you need to manually modify upstream Linux to make it happy --
since upstream Linux only cares about production hardware.

thanks,
-Len

