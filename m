Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965593AbbA2DfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:35:17 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45470 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521AbbA2DfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:35:12 -0500
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mpe@ellerman.id.au
Cc: rafael.j.wysocki@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH V2] cpuidle/powernv: Read target_residency value of idle states from DT if available
In-Reply-To: <54C8B0E6.5080406@linux.vnet.ibm.com>
References: <20150128021044.11166.81418.stgit@preeti.in.ibm.com> <m3wq47w9jj.fsf@oc8180480414.ibm.com> <54C8B0E6.5080406@linux.vnet.ibm.com>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-redhat-linux-gnu)
Date: Thu, 29 Jan 2015 09:24:33 +1100
Message-ID: <m3oapiwnku.fsf@oc8180480414.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012822-8236-0000-0000-0000090256E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preeti U Murthy <preeti@linux.vnet.ibm.com> writes:
> On 01/28/2015 02:45 PM, Stewart Smith wrote:
>> Preeti U Murthy <preeti@linux.vnet.ibm.com> writes:
>>> The device tree now exposes the residency values for different idle states. Read
>>> these values instead of calculating residency from the latency values. The values
>>> exposed in the DT are validated for optimal power efficiency. However to maintain
>>> compatibility with the older firmware code which does not expose residency
>>> values, use default values as a fallback mechanism. While at it, handle some
>>> cleanups.
>> 
>> From a "I just merged the patch that exports these values from firmware"
>> point of view, using them and falling back looks good.
>> 
>> (I find the hardcoding of snooze in the driver a bit odd, as is the
>
> Snooze is the only software defined idle state, the rest are platform
> specific. The first idle state is usually associated with some sort of a
> polling operation and each architecture has a variant to this. This is
> why we end up hard-coding this idle state in the driver as far as my
> understanding goes.

At least in the PowerISA 2.07 I could only see that lowering priority
would give priority to other threads in the core, I couldn't find
anything saying that or 31,31,31 would end up saving any power... but I
could be looking in the wrong place too.

Basically, I was wanting to check that it's actually written down and
architected somewhere that this is the case and it isn't something too
P7/P8 specific.

