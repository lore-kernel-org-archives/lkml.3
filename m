Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaCGTLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:11:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaCGTLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:11:16 -0500
Date: Fri, 7 Mar 2014 14:10:50 -0500
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307191050.GA10961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531A164B.8040402@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:56:11AM -0800, H. Peter Anvin wrote:
 > On 03/06/2014 09:50 PM, Fengguang Wu wrote:
 > >>
 > >> Unfortunately these things are hard to fix in Qemu.
 > > 
 > > OK. As an alternative, is it possible to pass one of the below CPUID flags in
 > > the Qemu command line, so as to quiet the warning?
 > > 
 > 
 > I don't see the AMD SMP CPUID flag in there.
 > 
 > Boris, could you help?  The problem is that "qemu -cpu
 > qemu64,+smep,+smap" identifies as an AMD CPU which triggers a
 > warning/taint because the SMP flag isn't set.

qemu64 triggers this ? That spew comes from amd_k7_smp_check() 
which should only run on family 6, which was all 32bit.

	Dave


