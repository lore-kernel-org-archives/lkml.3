Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbaKUQHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:07:01 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56915 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaKUQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:06:59 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-a3-546f63207e18
Message-id: <546F6319.6010305@samsung.com>
Date: Fri, 21 Nov 2014 19:06:49 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Ingo Molnar <mingo@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
 <5461B906.1040803@samsung.com>
 <20141118125843.434c216540def495d50f3a45@linux-foundation.org>
 <CAPAsAGwZtfzx5oM73bOi_kw5BqXrwGd_xmt=m6xxU6uECA+H9Q@mail.gmail.com>
 <20141120090356.GA6690@gmail.com>
 <CACT4Y+aOKzq0AzvSJrRC-iU9LmmtLzxY=pxzu8f4oT-OZk=oLA@mail.gmail.com>
 <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
 <alpine.DEB.2.11.1411210011530.6439@nanos>
In-reply-to: <alpine.DEB.2.11.1411210011530.6439@nanos>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHed67S+Ntaj7YB2sY0aiZEPUoEiUE74c+BK2wCGrN5SWnsqVp
	QZlXXGmmljkHSVrpHKibYbOpc4izLO8XdHlL81LN0sRMzXIuqG+/c87/nN+Xw+D8z4Q3ExF9
	VaaIlkQJKB7Rtm7t379TGiM+kGHwQav1hSTSVOoo1Nz/g0YDS18AmjRnALQwOwZQzUAyhqbH
	x2mUM55Oo4fVXqj8TgqFikYnCFQ7ZcdQeeYYiXrqNBQa0f0mUcX6G4C6zcUYSm3oxFD693US
	WbPMGLK/LyBQemk1hqwvanBU0mzD0dxUHo4M+gc4+pBtp1GftolGHb+sJFqumiCP+nCPjfOA
	M6qHaa5YH8cZyoRciWkW4/TaTIrTL+TSnMrei3Fz7e001/poleAmewswriQ7j+TmPw4R3KK2
	H+e+NvRR3NviZvqk+zleUKgsKiJepvA7cpEXbliux2KnyYSqeRueBJoIFXBhIHsQljYW0U7e
	DjtHKikV4DF89imAizU1hLNIwaB5qgV3pNxYIXxiSsUcTLC7ocGUtskUK4Lr6lrKwZ5sCOzV
	aYAzvw0u541s2jzY07DsWxVwHMXZfgZmWUo3j7qzp2BrueavOoWAua/XSMfAhT0M8xs1GwZm
	Y0MER7uEjjbO+kCDzo7nAFb9n0P9L6X+L1UMcC3wlMVJY5WXwuT+IqVEroyLDhNJY+R64HyQ
	xZegpCXQAlgGCFzdzMfkYj4piVcmyi0AMrjAw+2ae4yY7xYqSbwuU8RcUMRFyZQWgDEu3kmg
	esYg3pt940qv9cwzfsBKJNWyL8D6aX68ss59jy02+L5IOClIPztofH5IIyt8NeIiJLvfSY/r
	diSkSYNnkmc6XFVBCTfPN9q23Ns1dmvJty3J1nXitihXFR456NWeb/k5GbJ1eO5yhS+l6tFn
	rJiS+ux3A0cbJoxrflremnyIFRDKcIm/EFcoJX8ApFKzk/4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 02:14 AM, Thomas Gleixner wrote:
> On Thu, 20 Nov 2014, Andrew Morton wrote:
> 
>> On Thu, 20 Nov 2014 20:32:30 +0400 Dmitry Vyukov <dvyukov@google.com> wrote:
>>
>>> Let me provide some background first.
>>
>> Well that was useful.  Andrey, please slurp Dmitry's info into the 0/n
>> changelog?
> 
> And into Documentation/UBSan or whatever the favourite place is. 0/n
> lengthy explanations have a tendecy to be hard to retrieve.
> 

I would rather put this into 1/n patch changelog.
IMO Documentation should only describe how to use this tool and how it works.

And UBSan != KASan. UBSan for detecting undefined behavior,
KASan for out of bounds and use after frees.

> Thanks,
> 
> 	tglx
> 
> 
> 

