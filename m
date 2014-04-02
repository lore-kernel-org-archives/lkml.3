Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaDBCBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:01:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48565 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbaDBCBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:01:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <533B6EC0.10303@jp.fujitsu.com>
Date: Wed, 02 Apr 2014 10:58:24 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net> <20140331170546.3b3e72f0.akpm@linux-foundation.org> <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net> <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com> <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com> <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com> <20140401142947.927642a408d84df27d581e36@linux-foundation.org> <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com> <20140401144801.603c288674ab8f417b42a043@linux-foundation.org> <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail. gmail.co m> <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rH+vfFzRrh35TETxjFU2HM0xnDQFweQ+Bfw20Pm2nL3g@mail.gmail.com> <1396399239.25314.47.camel@buesod1.americas.hpqcorp.net> <xr937g78k06y.fsf@gthelen.mtv.corp.google.co
 m>
In-Reply-To: <xr937g78k06y.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/02 10:08), Greg Thelen wrote:
> 
> On Tue, Apr 01 2014, Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
>> On Tue, 2014-04-01 at 19:56 -0400, KOSAKI Motohiro wrote:
>>>>>> Ah-hah, that's interesting info.
>>>>>>
>>>>>> Let's make the default 64GB?
>>>>>
>>>>> 64GB is infinity at that time, but it no longer near infinity today. I like
>>>>> very large or total memory proportional number.
>>>>
>>>> So I still like 0 for unlimited. Nice, clean and much easier to look at
>>>> than ULONG_MAX. And since we cannot disable shm through SHMMIN, I really
>>>> don't see any disadvantages, as opposed to some other arbitrary value.
>>>> Furthermore it wouldn't break userspace: any existing sysctl would
>>>> continue to work, and if not set, the user never has to worry about this
>>>> tunable again.
>>>>
>>>> Please let me know if you all agree with this...
>>>
>>> Surething. Why not. :)
>>
>> *sigh* actually, the plot thickens a bit with SHMALL (total size of shm
>> segments system wide, in pages). Currently by default:
>>
>> #define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
>>
>> This deals with physical memory, at least admins are recommended to set
>> it to some large percentage of ram / pagesize. So I think that if we
>> loose control over the default value, users can potentially DoS the
>> system, or at least cause excessive swapping if not manually set, but
>> then again the same goes for anon mem... so do we care?
> 
> At least when there's an egregious anon leak the oom killer has the
> power to free the memory by killing until the memory is unreferenced.
> This isn't true for shm or tmpfs.  So shm is more effective than anon at
> crushing a machine.

Hm..sysctl.kernel.shm_rmid_forced won't work with oom-killer ?

http://www.openwall.com/lists/kernel-hardening/2011/07/26/7

I like to handle this kind of issue under memcg but hmm..tmpfs's limit is half
of memory at default.

Thanks,
-Kame








