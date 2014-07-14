Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaGNNgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:36:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:59721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbaGNNgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,658,1400050800"; 
   d="scan'208";a="572811499"
From: "Liang, Kan" <kan.liang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V5 1/2] perf ignore LBR and extra_regs
Thread-Topic: [PATCH V5 1/2] perf ignore LBR and extra_regs
Thread-Index: AQHPnG+hivFH9gFqr0Syb8Ke5/aDbZue9emAgAAEAACAAAi2gIAAjmog
Date: Mon, 14 Jul 2014 13:36:02 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014E1A91@SHSMSX103.ccr.corp.intel.com>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
 <53C3C517.4000500@redhat.com>
 <20140714120922.GV9918@twins.programming.kicks-ass.net>
 <53C3CFC1.9070800@redhat.com>
In-Reply-To: <53C3CFC1.9070800@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >>> For reproducing the issue, please build the kernel with
> CONFIG_KVM_INTEL = y (for host kernel).
> >>> And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest
> kernel).
> >>
> >> I'm not sure this is a useful patch.
> >>
> >> This is #GP'ing just because of a limitation in the PMU; just compile
> >> the kernel with CONFIG_PARAVIRT
> >
> > How's that going to help? If you run kvm -host the VM is lying through
> > its teeth is the kernel is going to assume all those MSRs present,
> > PARAVIRT isn't going to help with this.
> >
> >> , or split the "rdmsr is always rdmsr_safe"
> >> behavior out of CONFIG_PARAVIRT and into a new Kconfig symbol.
> >
> > That's not useful either, because non of these code-paths are going to
> > check the return value.
> 
> Hmmm, I thought rdmsr_safe was going to return zero, but it just returns
> whatever happened to be in edx:eax which maybe should also be fixed.
> 
> Kan Liang, what happens if CONFIG_PARAVIRT=y?  Do you get garbage or
> just no events reported?
> 

Guest rdmsr/wrmsr will eventually call rdmsr_safe/wrmsr_safe. They will handle the #GP. So there is no error report in guest.


