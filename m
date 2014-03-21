Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaCUT3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:29:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:35943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaCUT3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:29:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,704,1389772800"; 
   d="scan'208";a="505069478"
Date: Fri, 21 Mar 2014 12:29:38 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Message-ID: <20140321192938.GJ3132@tassilo.jf.intel.com>
References: <4055058.qLAukpngnj@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4055058.qLAukpngnj@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 06:42:40PM +0100, Peter Wu wrote:
> Hi,
> 
> While trying to run QEMU with `-enable-kvm -host cpu`, I get a GPF in
> intel_pmu_lbr_reset():

Same problem as the RAPL problem earlier. KVM is lying to the guest 
that it is a host CPU, but not implementing all MSRs the host
CPU supports.

KVM should really return 0 on unknown MSRs not #GP

-Andi
