Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaK0Qjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:39:36 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaK0Qje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:39:34 -0500
Message-ID: <547753C0.6050604@nod.at>
Date: Thu, 27 Nov 2014 17:39:28 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
References: <1416835236-25185-1-git-send-email-richard@nod.at>		 <1416835236-25185-3-git-send-email-richard@nod.at>	 <1417102042.5858.102.camel@sauron.fi.intel.com> <54774DB7.5090200@nod.at> <1417106151.5858.122.camel@sauron.fi.intel.com>
In-Reply-To: <1417106151.5858.122.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.11.2014 um 17:35 schrieb Artem Bityutskiy:
> On Thu, 2014-11-27 at 17:13 +0100, Richard Weinberger wrote:
>> Am 27.11.2014 um 16:27 schrieb Artem Bityutskiy:
>>> On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
>>>> If the WL pool runs out of PEBs we schedule a fastmap write
>>>> to refill it as soon as possible.
>>>> Ensure that only one at a time is scheduled otherwise we might end in
>>>> a fastmap write storm because writing the fastmap can schedule another
>>>> write if bitflips are detected.
>>>
>>> Could you please provide some more details about the "write storm". Does
>>> it happen when there are 2 fastmap works in the queue? Or if they run
>>> simultaneously? Why the storm happens and white kind of "writes" it
>>> consists of?
>>
>> If UBI needs to write a new fastmap while wear leveling (by using get_peb_for_wl())
>> a fastmap work is scheduled.
>> We cannot write a fastmap in this context because we're in atomic context.
>> At this point one fastmap write is scheduled. If now get_peb_for_wl() is executed
>> a second time it will schedule another fastmap work because the pools are still not refilled.
> 
> Sounds like just you do not need any works and any queues at all. All
> you need is a "please, fastmap me!" flag.
> 
> Then this flag should be checked every time we enter the background
> thread or the fastmap code, and be acted upon.
> 
> So the background thread would first check this flag, and if it is set -
> call the fastmap stuff. The go do the WL works.
> 
> Just off-the top of my head, take with grain of salt.

So you want me to redesign it?
IMHO this is just a matter of taste.

Face it, my brain does not work like yours. I design things differently.

Thanks,
//richard

