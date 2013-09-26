Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3IZBjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:39:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:64085 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3IZBjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:39:06 -0400
Message-ID: <52439022.9080407@windriver.com>
Date: Thu, 26 Sep 2013 09:38:42 +0800
From: Ming Liu <ming.liu@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <akpm@linux-foundation.org>, <mhocko@suse.cz>, <rusty@rustcorp.com.au>,
        <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oom: avoid killing init if it assume the oom killed thread's
 mm
References: <1379929528-19179-1-git-send-email-ming.liu@windriver.com> <alpine.DEB.2.02.1309241933590.26187@chino.kir.corp.google.com> <52427970.8010905@windriver.com> <alpine.DEB.2.02.1309251056020.17676@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1309251056020.17676@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 01:56 AM, David Rientjes wrote:
> On Wed, 25 Sep 2013, Ming Liu wrote:
>
>>> We shouldn't be selecting a process where mm == init_mm in the first
>>> place, so this wouldn't fix the issue entirely.
>> But if we add a control point for "mm == init_mm" in the first place(ie. in
>> oom_unkillable_task), that would forbid the processes sharing mm with init to
>> be selected, is that reasonable? Actually my fix is just to protect init
>> process to be killed for its vfork child being selected and I think it's the
>> only place where there is the risk. If my understanding is wrong, pls correct
>> me.
>>
> We never want to select a process where task->mm == init_mm because if we
> kill it we won't free any memory, regardless of vfork().  The goal of the
> oom killer is solely to free memory, so it always tries to avoid needless
> killing.
Yes, that make sense, I will send the V1 patch.

the best,
thank you
>
>

