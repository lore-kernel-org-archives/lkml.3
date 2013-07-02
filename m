Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3GBGSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:18:00 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35342 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3GBGR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:17:58 -0400
Message-ID: <51D2708C.1050901@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 14:17:48 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <1372744486.7363.133.camel@marge.simpson.net>
In-Reply-To: <1372744486.7363.133.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070206-1618-0000-0000-00000430BB1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 01:54 PM, Mike Galbraith wrote:
> On Tue, 2013-07-02 at 12:43 +0800, Michael Wang wrote: 
>> Since RFC:
>> 	Tested again with the latest tip 3.10.0-rc7.
>>
>> wake-affine stuff is always trying to pull wakee close to waker, by theory,
>> this will bring benefit if waker's cpu cached hot data for wakee, or the
>> extreme ping-pong case.
>>
>> And testing show it could benefit hackbench 15% at most.
> 
> How much does this still help with Alex's patches integrated?

I remember Alex already tested hackbench, and for wake_affine(), his
patch set is some kind of load filter, mine is nr_wakee filter, they are
separated, but I will do more test on this point when it become the last
concern.

> 
> aside: were I a maintainer, I'd be a little concerned that what this
> helps with collides somewhat with the ongoing numa work.

As Peter mentioned before, we currently need some solution like the
buddy-idea, and when folks report regression (I suppose they won't...),
we will have more data then.

So we could firstly try to regain the lost performance of pgbench, if it
strip the benefit of other benchmarks, let's fix it, and at last we will
have a real smart wake-affine and no one will complain ;-)

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

