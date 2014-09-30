Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaI3Hol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:44:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaI3Hok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:44:40 -0400
Message-ID: <542A5F64.5000302@nod.at>
Date: Tue, 30 Sep 2014 09:44:36 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
CC: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 4/4] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
References: <1412029248-22454-1-git-send-email-richard@nod.at>		 <1412029248-22454-5-git-send-email-richard@nod.at>	 <1412059523.3904.11.camel@sauron.fi.intel.com> <542A54E4.2060407@nod.at> <1412062762.2379.2.camel@sauron.fi.intel.com>
In-Reply-To: <1412062762.2379.2.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.09.2014 09:39, schrieb Bityutskiy, Artem:
> On Tue, 2014-09-30 at 08:59 +0200, Richard Weinberger wrote:
>> Am 30.09.2014 08:45, schrieb Bityutskiy, Artem:
>>> On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
>>>> +       spin_lock(&ubi->wl_lock);
>>>> +       ubi->fm_work_scheduled = 0;
>>>> +       spin_unlock(&ubi->wl_lock);
>>>
>>> Andrew Morton once said me that if I am protecting an integer change
>>> like this with a spinlock, I have a problem in my locking design. He was
>>> right for my particular case.
>>>
>>> Integer is changes atomic. The only other thing spinlock adds are the
>>> barriers.
>>
>> I've added the spinlock to have a barrier in any case.
> 
> Examples of any?

You mean a case where the compiler would reorder code and the barrier is needed?
I don't have one, but I'm not that creative as a modern C compiler.
If you say that no barrier is needed I'll trust you. :-)

Thanks,
//richard

