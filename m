Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab3GBGpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:45:35 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50912 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3GBGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:45:34 -0400
Message-ID: <51D27704.20908@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 14:45:24 +0800
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
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <1372744486.7363.133.camel@marge.simpson.net> <51D2708C.1050901@linux.vnet.ibm.com> <1372746555.7363.147.camel@marge.simpson.net>
In-Reply-To: <1372746555.7363.147.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070206-5490-0000-0000-000003BF379B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 02:29 PM, Mike Galbraith wrote:
> On Tue, 2013-07-02 at 14:17 +0800, Michael Wang wrote:
> 
>> As Peter mentioned before, we currently need some solution like the
>> buddy-idea, and when folks report regression (I suppose they won't...),
>> we will have more data then.
>>
>> So we could firstly try to regain the lost performance of pgbench, if it
>> strip the benefit of other benchmarks, let's fix it, and at last we will
>> have a real smart wake-affine and no one will complain ;-)
> 
> The idea is plenty simple (and the fastpath has a deep and abiding love
> of simple) so the idea itself flies in my book.  It doesn't add as much
> knowledge as may be nice to have, but if it adds enough to help pgbench
> and ilk without harming others, cool.

Nice to know you like it ;-)

There are some thinking behind the idea, since the knob is unacceptable,
I try to make the filter more strict, we actually
could get all the lost 50% performance back, but will run the risk to
strip other's benefit (like hackbench), but if just get 40% performance
back, then we may could reduce the risk nearly to 0.

So the principle of this idea is to filter out the extremely bad cases,
and we make sure under such cases, the chances of mess things up is very
high, thus the wake_affine() will become a little smart and know to stop
in front of the cliff...

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

