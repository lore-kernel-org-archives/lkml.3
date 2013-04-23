Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3DWEFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:05:18 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36123 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3DWEFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:05:17 -0400
Message-ID: <51760871.1030607@linux.vnet.ibm.com>
Date: Tue, 23 Apr 2013 12:05:05 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1366626208.2721.12.camel@laptop> <20130422103521.GA14103@gmail.com>
In-Reply-To: <20130422103521.GA14103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042303-5816-0000-0000-000007A94BA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:35 PM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> OK,.. Ingo said that pipe-test was the original motivation for 
>> wake_affine() and since that's currently broken to pieces due to 
>> select_idle_sibling() is there still a benefit to having it at all?
>>
>> Can anybody find any significant regression when simply killing 
>> wake_affine()?
> 
> I'd suggest doing a patch that does:
> 
>    s/SD_WAKE_AFFINE/0*SD_WAKE_AFFINE

But by doing this, we won't be able to find 'affine_sd' any more, that
will also skip the select_idle_sibling() logical (in current code),
isn't it?

If we really want to kill the stuff (I prefer not...), I suggest we
forbidden the wake-affine by throttle it with an incredible interval,
that's also easily to be reverted :)

Regards,
Michael Wang

> 
> in all the relevant toplogy.h files, but otherwise keep the logic in 
> place. That way it's easy to revert.
> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

