Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbbA1UV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:21:27 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49981 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbbA1UVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:21:24 -0500
Message-ID: <54C8B0E6.5080406@linux.vnet.ibm.com>
Date: Wed, 28 Jan 2015 15:20:30 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stewart Smith <stewart@linux.vnet.ibm.com>, mpe@ellerman.id.au
CC: rafael.j.wysocki@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH V2] cpuidle/powernv: Read target_residency value of idle
 states from DT if available
References: <20150128021044.11166.81418.stgit@preeti.in.ibm.com> <m3wq47w9jj.fsf@oc8180480414.ibm.com>
In-Reply-To: <m3wq47w9jj.fsf@oc8180480414.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012809-0009-0000-0000-000008515FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 02:45 PM, Stewart Smith wrote:
> Preeti U Murthy <preeti@linux.vnet.ibm.com> writes:
>> The device tree now exposes the residency values for different idle states. Read
>> these values instead of calculating residency from the latency values. The values
>> exposed in the DT are validated for optimal power efficiency. However to maintain
>> compatibility with the older firmware code which does not expose residency
>> values, use default values as a fallback mechanism. While at it, handle some
>> cleanups.
> 
> From a "I just merged the patch that exports these values from firmware"
> point of view, using them and falling back looks good.
> 
> (I find the hardcoding of snooze in the driver a bit odd, as is the

Snooze is the only software defined idle state, the rest are platform
specific. The first idle state is usually associated with some sort of a
polling operation and each architecture has a variant to this. This is
why we end up hard-coding this idle state in the driver as far as my
understanding goes.

> hardcoding of max power states to 8 - which could bite us in the future

Hmm.. not sure about this. Need to check.

> if a future processor has more states... but these aren't problems with
> this patch)
> 
> Acked-by: Stewart Smith <stewart@linux.vnet.ibm.com>

Thanks!

Regards
Preeti U Murthy
> 

