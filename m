Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941Ab3CZCqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:46:03 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33163 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab3CZCqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:46:01 -0400
Message-ID: <51510BBE.5050802@linux.vnet.ibm.com>
Date: Tue, 26 Mar 2013 10:45:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH] sched: wake-affine throttle
References: <514FDF76.2060806@linux.vnet.ibm.com> <1364203359.4559.66.camel@marge.simpson.net> <51502513.6010607@linux.vnet.ibm.com> <1364221915.4559.188.camel@marge.simpson.net>
In-Reply-To: <1364221915.4559.188.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 13032602-5140-0000-0000-000002F1687A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 10:31 PM, Mike Galbraith wrote:
[snip]
>>
>> Do you mean 1ms interval is still too big? and you prefer to have a 0
>> option?
> 
> Not really, I just think a fixed interval may not be good enough without
> some idle time consideration.  Once a single load gets going less
> balancing is more, it's just when load is fluctuating a lot, and mixed
> loads where I can imagine troubles.
> 
> Perhaps ramp up to knob interval after an idle period trigger of.. say
> migration_cost, or whatever.  Something dirt simple that makes it open
> the gates when it's most likely to matter.
> 

So a dynamically adjustment, sounds attractively ;-)

However, IMHO, I don't think we could be able to figure out when to
adjust and how to adjust, actually we even don't have the data to count
on, otherwise, there is no necessary to throttle the wake-affine stuff
at all...

May be do such work in user space will be better?

This knob is nothing but compromise, besides, it's a highlight to notify
us we still have a feature waiting for improve, if later we have the way
to build an accurate wake-affine, remove the knob should be easy.

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

