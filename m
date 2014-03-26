Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaCZOIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:08:53 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:65248 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbaCZOIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <5332BD50.1070600@linux.vnet.ibm.com>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
	<535a552cd2c05a3ae2cb61da2583646e1c649699.1395832156.git.viresh.kumar@linaro.org>
	<5332BD50.1070600@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 19:38:51 +0530
Message-ID: <CAKohpokM=VKH6EV+3R+Ec4wQO240Yr78F_kDphMOR481+4GUPw@mail.gmail.com>
Subject: Re: [LNG] Re: [PATCH 04/14] hrtimer: use base->index instead of
 basenum in switch_hrtimer_base()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2014 17:13, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> +     new_base = &new_cpu_base->clock_base[base->index];
>
> Further down, timer->base can be altered (and set to NULL too).
> So if we jump back to 'again', we'll end up in trouble.
> So I think its important to cache the value in basenum and
> use it.

base is a parameter to this function and never changes. So
base->index is guaranteed to be valid and same during a functions call.
