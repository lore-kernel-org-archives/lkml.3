Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3GDJir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:38:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59814 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3GDJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:38:46 -0400
Message-ID: <51D5428D.7080805@linux.vnet.ibm.com>
Date: Thu, 04 Jul 2013 17:38:21 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <20130702085202.GA23916@twins.programming.kicks-ass.net> <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net>
In-Reply-To: <20130704091339.GK18898@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070409-5140-0000-0000-00000378C57C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:13 PM, Peter Zijlstra wrote:
[snip]
> 
> Right, but something like the below is limited in cost to at most 32/64 (I
> forgot the type) shifts. Now its probably not worth doing, but it shows
> things like that can be done in 'constant' time.
> 
>   now = jiffies;
>   if (now - p->last_switch_decay > 8*sizeof(p->nr_wakee_switch)*HZ) {
> 	p->nr_wakee_switch = 0;
> 	p->last_switch_decay = now;
>   } else while (now > p->last_switch_decay + HZ) {
> 	p->nr_wakee_switch >>= 1;
> 	p->last_switch_decay += HZ;
>   }

Hmm...interesting, some kind of cataclysm decay, not sure how it works
but yes, the cost was capped.

Well, seems like we still have many follow-up research works after fix
the issue ;-)

Regards,
Michael Wang

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

