Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaCUVmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:42:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaCUVmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:42:21 -0400
Message-ID: <532CB21B.4040502@zytor.com>
Date: Fri, 21 Mar 2014 14:41:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Peter Wu <peter@lekensteyn.nl>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
References: <4055058.qLAukpngnj@al> <20140321192938.GJ3132@tassilo.jf.intel.com> <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com> <20140321213753.GK3132@tassilo.jf.intel.com>
In-Reply-To: <20140321213753.GK3132@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 02:37 PM, Andi Kleen wrote:
> On Fri, Mar 21, 2014 at 01:46:04PM -0700, H. Peter Anvin wrote:
>> Not really.  That is equally braindamaged.  The problem is that KVM is telling the host that our is something it simply cannot be.
> 
> Well it has to pick something. It's unlikely it will ever implement 100% of that particular CPU.
> 0 is the best you can get in many cases.
> 
> Also I thought Xen did return 0.
> 

That's why at least to some extent The Right Thing is not to try to
pretend to be a CPU you don't even know how to emulate.

But again, that has its own issues, too, mostly with userspace
optimization, and making the Linux code more resilient wouldn't hurt.
In that sense #GP(0) is *much* better than 0: it unambiguously gives an
error to work with.

However, labeling it a bug in Linux is silly.

	-hpa

