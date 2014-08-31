Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaHaT0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:26:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:36891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaHaT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:26:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379501291"
Message-ID: <540376CE.2050007@linux.intel.com>
Date: Sun, 31 Aug 2014 12:26:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Tejun Heo <tj@kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        falcon@meizu.com, tiwai@suse.de, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com> <20140831101358.GB19853@htj.dyndns.org> <20140831110200.GC19853@htj.dyndns.org> <20140831110526.GE19853@htj.dyndns.org> <20140831175243.GB17827@core.coreip.homeip.net>
In-Reply-To: <20140831175243.GB17827@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2014 10:52 AM, Dmitry Torokhov wrote:
> On Sun, Aug 31, 2014 at 07:05:26AM -0400, Tejun Heo wrote:
>> On Sun, Aug 31, 2014 at 07:02:00AM -0400, Tejun Heo wrote:
>>> So, something like the following.  A couple things to note
>>>
>>> * driver_attach() can never fail but is marked with __must_check.  We
>>>    prolly should change it to void.
>>>
>>> * Old/weird userspace which depends on insmod to wait for device
>>>    probing might choke and the new behavior might need to be switched
>>>    somehow (sysctl, insmod param or whatever).
>>
>> One more thing.
>>
>> * Use of ordered workqueue probably isn't necessary and using
>>    system_unbound_wq should be fine.
>>
>
> For my use case (touchpad taking long time to initialize) I explicitly do not
> want it to keep order of initialization. I want to make sure the rest of the
> kernel continues initialization while touchpad device resets.

but we do that right now

you know its there synchronous
and do the heavy stuff async


now sadly  we also wait for the touchpad to finish init if you don't use an initramfs
(but we dont wait if you have an initramfs) but that's a different thing from all of this

