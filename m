Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3FYT7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:59:32 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:12565 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FYT7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:59:30 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-8c-51c9f6a13c14
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
Date: Tue, 25 Jun 2013 19:59:28 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
 <CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
 <CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
 <20130625125437.6e7bb2d4@jbarnes-desktop>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9hP92F304GGty6qmJx9dYCJoubD8+y
	Wix8eJfZYvaEzUwWj86cZLe4vGsOm8XXnw4Wj/resjtweKz8oOWx99sCFo+ds+6ye5yY8ZvF
	4373cSaP9/uusnl83iTn8e3rXqYAjigum5TUnMyy1CJ9uwSujA239jIWvOGs6OubxNTA+Ie9
	i5GDQ0LAROLe2qguRk4gU0ziwr31bF2MXBxCAssYJS78WQbl9DJJ3Li7gxHCmc8o8e37EnaQ
	FjYBdYnPr3eA2SIC2hI/5pwEK2IWeMYk8evmVlaQFcIC0hIvD8lA1MhIzGz9yAph60mc+ncO
	zGYRUJVYMn8jC4jNK2Avce7jViaIZYeYJK61HwIrYgS67/upNUwgNrOAuERz600WiLsFJJbs
	Oc8MYYtKvHz8jxXiNUWJ7autIMq1JNbvPA7Vqi3x5N0FVohdghI/Jt9jmcAoNgvJ1FlIWmYh
	aZmFpGUBI8sqRrHS4uSC4qT01ApjveLE3OLSvHS95PzcTYyQqK3ZwXjvq80hRgEORiUe3hOb
	TgYKsSaWFVfmHmKU4GBWEuHNvwEU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLik+f+eEq/+AF9/
	25zAs9uS47f3HpQoKk5c92TOlFebYnOlXEMcd+feXzlVTeHZ38yL3dZufEe8PNlqI0ND2ip7
	2O+/092jEtZ9VXuNWe/+XK00JW6XJ9aTQy4UcURPKct62bhk79qrRp1rVR+cyDt/t+3S+qaP
	jxauXKb10s4pWmuxxQuvfiWW4oxEQy1moJUA8C3hDrgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 01:52 PM, Jesse Barnes wrote:
> On Tue, 25 Jun 2013 21:37:37 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>

>>
>> Adding more lists to cc + Jesse since he's the guilty one for the
>> vt-switchless state restore stuff.
>
> Yeah, looks like we don't fetch the PLL state on resume from hibernate,
> leading to this warning.  The refcount is nonzero, indicating the pll
> is in use, but the active field is clear, which means we're missing an
> update somewhere.
>
> Shuah, just to confirm, does your resume actually work ok aside from
> the warning?  I *think* it's harmless in this case, but does indicate a
> real bug in our state tracking... trying to come up with a patch now.
>
> Thanks,
>

Resume works just fine. I see it take longer for it to suspend compared 
to 3.9.7 and then resumes just fine. Suspend taking longer very well 
could be because of this warn_on. Other than this warn_on I haven't 
noticed any other problems.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
