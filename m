Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaCVO5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 10:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaCVO5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 10:57:42 -0400
Message-ID: <532DA4D8.60102@redhat.com>
Date: Sat, 22 Mar 2014 10:57:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: lwcheng@cs.hku.hk
CC: Glauber Costa <glommer@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Paravirtual time accounting / IRQ time accounting
References: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk> <CAA6-i6p-=4Dk9-ujvL36EVpm80MS-BiYjw+V9JQ8g4AypBJeZw@mail.gmail.com> <532C232E.5000607@redhat.com> <20140322151540.9740576amzy5tdwk@intranet.cs.hku.hk>
In-Reply-To: <20140322151540.9740576amzy5tdwk@intranet.cs.hku.hk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2014 03:15 AM, lwcheng@cs.hku.hk wrote:

> I observe that sometimes irq_time only includes "part" of steal_time.
> 
> Like you said, irq_time is in dozens-of-microseconds. In VMs, as all
> devices seen are virtual ones, irq_time seems to be not as desired
> as it is in physical hosts.
> 
> A quick (but not radical) solution may be:
> disable CONFIG_IRQ_TIME_ACCOUNTING if CONFIG_PARAVIRT is selected.
> Just adopt tick-based accounting: CONFIG_TICK_CPU_ACCOUNTING
> 
> I am thinking what irq_time really *means* in VMs.

That is not really an option for Linux distributions, which tend
to run the same kernel image on the host and in the guest...

-- 
All rights reversed
