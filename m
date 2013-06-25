Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3FYUvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:51:31 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:33511 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3FYUva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:51:30 -0400
X-AuditID: cbfec37b-b7f306d0000047de-ad-51ca02d0422d
From: Shuah Khan <shuah.kh@samsung.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: Linux 3.10-rc7
Thread-topic: Linux 3.10-rc7
Thread-index: AQHOcO9Wy94BEELWoUiZdIX6E3dp1w==
Date: Tue, 25 Jun 2013 20:51:27 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617306DD@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
 <CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
 <CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
 <20130625125437.6e7bb2d4@jbarnes-desktop>
 <B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
 <20130625130816.55e6cb80@jbarnes-desktop>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9hX90LTKcCDY73aVpcvbWAyeLmw7Os
	Fgsf3mW2mD1hM5PFozMn2S0u75rDZvH1p4PFo7637A4cHis/aHns/baAxWPnrLvsHidm/Gbx
	uN99nMnj/b6rbB6fN8l5fPu6lymAI4rLJiU1J7MstUjfLoEr49nttcwF5wUq/q/8wtbAeJi3
	i5GTQ0LARKJjZx8jhC0mceHeerYuRi4OIYFljBJXf21kgXB6mSR61vaDVQkJzGeUWHEvF8Rm
	E1CX+Px6BzuILSKgLfFjzklGkAZmgWdMEr9ubmXtYuTgEBaQlnh5SAaiRkZiZutHVghbT+LU
	v3NgNouAqsSpjnVg83kF7CVaJz+DWryEWeLu1DdMIAlGoPO+n1oDZjMLiEs0t95kgThbQGLJ
	nvPMELaoxMvH/8D2SggoSmxfbQVRriWxfudxqFZtiSfvLrBC7BKU+DH5HssERrFZSKbOQtIy
	C0nLLCQtCxhZVjGKlRYnFxQnpadWGOkVJ+YWl+al6yXn525ihERt9Q7Gu19tDjEKcDAq8fCe
	2HQyUIg1say4MvcQowQHs5IIb/4NoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGiUgOy5Tpd/gm
	ve4VfmVux8nKtubx6w9v/UTuv/P7YXi/Ii49YfU6pasbfl6Ns16dJWkzcYroaZ2aA2U/zly7
	u/66VeurNeulVzJo/rXxltiuXyO98YltUCLD28ibmnevPNI+yaq9RMBVyvk235dIV5kl8+wM
	ZGtqtz4LfFD+dPJn2Wfu13d3KbEUZyQaajEXFScCAE2opca4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:06 PM, Jesse Barnes wrote:
> On Tue, 25 Jun 2013 19:59:28 +0000
> Shuah Khan <shuah.kh@samsung.com> wrote:
>
>> On 06/25/2013 01:52 PM, Jesse Barnes wrote:
>>> On Tue, 25 Jun 2013 21:37:37 +0200
>>> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>>
>>
>>>>
>>>> Adding more lists to cc + Jesse since he's the guilty one for the
>>>> vt-switchless state restore stuff.
>>>
>>> Yeah, looks like we don't fetch the PLL state on resume from hibernate,
>>> leading to this warning.  The refcount is nonzero, indicating the pll
>>> is in use, but the active field is clear, which means we're missing an
>>> update somewhere.
>>>
>>> Shuah, just to confirm, does your resume actually work ok aside from
>>> the warning?  I *think* it's harmless in this case, but does indicate a
>>> real bug in our state tracking... trying to come up with a patch now.
>>>
>>> Thanks,
>>>
>>
>> Resume works just fine. I see it take longer for it to suspend compared
>> to 3.9.7 and then resumes just fine. Suspend taking longer very well
>> could be because of this warn_on. Other than this warn_on I haven't
>> noticed any other problems.
>
> Here's the patch I'm testing now, can you give it a try?
>

Jesse,

With this patch warn_on went away. Resume worked. I started seeing:

[   78.733062] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[   78.733079] mei_me 0000:00:16.0: reset: wrong host start response
[   78.733082] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING

over and over again after resume from reboot mode suspend. dmesg filled 
up with these messages.

I did suspend to disk shutdown mode right away. Resume worked, no 
warn_ons, and no mei_me messages.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
