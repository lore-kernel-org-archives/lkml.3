Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaDWI5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:57:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44609 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaDWI5o convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 23 Apr 2014 04:57:44 -0400
Message-Id: <53579CA4020000780000B342@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 23 Apr 2014 09:57:40 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@Citrix.com>, <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when
 migrating.
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-2-git-send-email-konrad@kernel.org>
 <534529A40200007800007055@nat28.tlf.novell.com>
 <20140409152706.GF5860@phenom.dumpdata.com>
 <5345853502000078000074F8@nat28.tlf.novell.com>
 <20140422183443.GA6817@phenom.dumpdata.com>
In-Reply-To: <20140422183443.GA6817@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.04.14 at 20:34, <konrad.wilk@oracle.com> wrote:
> With this patch:
> [...]
> And with an HVM guest poking at the rest of VCPUOPs: VCPUOP_get_physid, 
> VCPUOP_initialise, and VCPUOP_send_nmi - either before the CPU is up or
> when it is up - work.
> 
> That is: the VCPUOP_get_physid would return -EINVAL; VCPUOP_initialise
> would return either -EEXIST or 0, and in either case
> the content of the ctxt was full of zeros.

Good.

> The VCPUOP_send_nmi did cause the HVM to get an NMI and it spitted out
> 'Dazed and confused'. It also noticed corruption:
> 
> [    3.611742] Corrupted low memory at c000fffc (fffc phys) = 00029b00
> [    2.386785] Corrupted low memory at ffff88000000fff8 (fff8 phys) = 
> 2990000000000
> 
> Which is odd because there does not seem to be anything in the path
> of hypervisor that would cause this.

Indeed. This looks a little like a segment descriptor got modified here
with a descriptor table base of zero and a selector of 0xfff8. That
corruption needs to be hunted down in any case before enabling
VCPUOP_send_nmi for HVM.

Jan

