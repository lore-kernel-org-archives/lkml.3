Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHaWsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 18:48:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:6157 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHaWsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 18:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379537710"
Message-ID: <5403A625.4020801@linux.intel.com>
Date: Sun, 31 Aug 2014 15:48:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?UTF-8?B?5ZC056ug6YeR?= <falcon@meizu.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "penguin-kernel@i-love.sakura.ne.jp" 
	<penguin-kernel@i-love.sakura.ne.jp>,
        "joseph.salisbury@canonical.com" <joseph.salisbury@canonical.com>,
        "bpoirier@suse.de" <bpoirier@suse.de>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
References: <99jhsb6abtsilpt3j5nu991b.1409513632114@email.android.com> <5403A273.4070504@linux.intel.com> <e781dc3b-5829-4bce-8a34-7ed708309f3b@email.android.com>
In-Reply-To: <e781dc3b-5829-4bce-8a34-7ed708309f3b@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2014 3:45 PM, Dmitry Torokhov wrote:
> On August 31, 2014 3:32:19 PM PDT, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> On 8/31/2014 1:06 PM, 吴章金 wrote:
>>> Hi, folks
>>>
>>> I'm back to this discussion,
>>>
>>> The original requirement of my first RFC patchset is mainly for
>> Android Smartphone use case:
>>>
>>> 1. We want light on LCD and draw a logo immediately after power key
>> press(don't consider uboot or lk biotloader here).
>>> 2. We want the whole kernel boot fast to give user the Android Launch
>> deaktop
>>> 3. The modem initialization/reset is slow
>>> 4. The Touchpad firmware upgrade is slow
>>> 5. We have many cpu cores(up to 8 in latest exynos 5430 and
>> MT6595...)
>>> 6. We have few schedulable/parallellizable threads
>>> 7. We compiled all of the modules in the kernel(stupid? avoid
>> modprobe...but lose parallelization in userspace)
>>>
>>> So, I think about is that possible to async most of the probes, but
>> still reserve the requred dependencies to let them still work as
>> expected.
>>
>> you can boot a whole kernel including all graphics in less than 0.5
>> seconds, even without this patchset.
>
>
> You forgot to add "on certain subset of hardware and configuration".

certainly.

for hardware that takes longer than 0.5s you certainly won't get that.

asynchronous/parallel init helps, but it is not a miracle. Most devices I've worked on
(wide range of hardware from PC to tablets to phones) there tend to be 4 to 5 big guys and a long tail of negliable ones.
the big guys tend to be, even after going in parallel, so large that people who wanted instant boot have to accept
that more miracles are needed.
Like actual work in the driver or device firmware to split work up, rather than an "from the outside" make it asynchronous.

