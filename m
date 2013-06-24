Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3FXWIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:08:52 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55894 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071Ab3FXWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:08:50 -0400
Message-ID: <51C8C36B.9020605@hurleysoftware.com>
Date: Mon, 24 Jun 2013 18:08:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Alex Shi <alex.shi@intel.com>, Michel Lespinasse <walken@google.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] rwsem: do optimistic spinning for writer lock acquisition
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>  <1371858700.22432.5.camel@schen9-DESK>  <51C558E2.1040108@hurleysoftware.com> <1372111092.22432.84.camel@schen9-DESK>
In-Reply-To: <1372111092.22432.84.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 05:58 PM, Tim Chen wrote:
> On Sat, 2013-06-22 at 03:57 -0400, Peter Hurley wrote:
>> Will this spin for full scheduler value on a reader-owned lock?
>>
>>> +		/* wait_lock will be acquired if write_lock is obtained */
>>> +		if (rwsem_try_write_lock(sem->count, true, sem)) {
>>> +			ret = 1;
>>> +			goto out;
>>> +		}
>>> +
>>> +		/*
>>> +		 * When there's no owner, we might have preempted between the
>>                                                           ^^^^^^^^
>>
>> Isn't pre-emption disabled?
>>
>
> Peter, on further review, this code is needed.  This code guard against
> the case of this thread preempting another thread in the middle
> of setting the  owner field.  Disabling preemption does not prevent this
> thread from preempting others, even though others cannot preempt
> this thread.

Yep; so the "we" in the quoted comment really refers to another thread
executing down_write_xxxx().

Thanks for the clarification.

Regards,
Peter Hurley
