Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaCUUr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:47:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40243 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaCUUrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:47:18 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140321192938.GJ3132@tassilo.jf.intel.com>
References: <4055058.qLAukpngnj@al> <20140321192938.GJ3132@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Mar 2014 13:46:04 -0700
To: Andi Kleen <ak@linux.intel.com>, Peter Wu <peter@lekensteyn.nl>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Message-ID: <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not really.  That is equally braindamaged.  The problem is that KVM is telling the host that our is something it simply cannot be.

On March 21, 2014 12:29:38 PM PDT, Andi Kleen <ak@linux.intel.com> wrote:
>On Fri, Mar 21, 2014 at 06:42:40PM +0100, Peter Wu wrote:
>> Hi,
>> 
>> While trying to run QEMU with `-enable-kvm -host cpu`, I get a GPF in
>> intel_pmu_lbr_reset():
>
>Same problem as the RAPL problem earlier. KVM is lying to the guest 
>that it is a host CPU, but not implementing all MSRs the host
>CPU supports.
>
>KVM should really return 0 on unknown MSRs not #GP
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
