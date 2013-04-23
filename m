Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab3DWECF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:02:05 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50143 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3DWECC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:02:02 -0400
Message-ID: <517607AD.2010902@linux.vnet.ibm.com>
Date: Tue, 23 Apr 2013 12:01:49 +0800
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
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1366626208.2721.12.camel@laptop>
In-Reply-To: <1366626208.2721.12.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042303-8256-0000-0000-0000072DB190
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:23 PM, Peter Zijlstra wrote:
> 
> OK,.. Ingo said that pipe-test was the original motivation for
> wake_affine() and since that's currently broken to pieces due to
> select_idle_sibling() is there still a benefit to having it at all?
> 
> Can anybody find any significant regression when simply killing
> wake_affine()?

IMHO, reserve this stuff may be a better choice, it do bring benefit,
pgbench is just some workload it also bring damage.

By throttle, we could reduce the damage meanwhile reserve the benefit,
when reach some rate, they will be balanced and show best performance, I
suppose just killing the stuff won't show that peak...

Besides, we still have many theory about the possible benefit of this
stuff, along with some side-effect like speared behaviour, it has been
there too long, the influence of killing it is unmeasurable (tend to be
worse), I really prefer to reserve it...

And if we really want to kill it, we could just throttle it with an
incredible interval, and make it unable to breathe any more ;-)

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

