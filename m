Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaKJM1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:27:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59258 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaKJM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAGC3nLCaX06n5Nw5ND-wg0_dtD-fD8Pn+CjP-BW8OJK5hz58Kg@mail.gmail.com>
References: <1415004836-22871-1-git-send-email-danieru.dressler@gmail.com>
	<20141107134854.56305dbb@lwn.net>
	<CAGC3nLBsX9fEjjmX2OGKnyTxuxbV_FNfndsoPbjob4UQqpuPpg@mail.gmail.com>
	<CAAXmX-kid7K8kWGnhe-AahrqHPiwpnggfQbVBD+A3cVK6rmAuQ@mail.gmail.com>
	<CAGC3nLCaX06n5Nw5ND-wg0_dtD-fD8Pn+CjP-BW8OJK5hz58Kg@mail.gmail.com>
Date: Mon, 10 Nov 2014 10:27:15 -0200
Message-ID: <CAAXmX-n4rvseguwsDDf+=HJWkxWJ=FzSzCC7eR1ve8FqB3AQ2Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] Input: xpad - update docs to reflect current state
From: Thomaz de Oliveira dos Reis <thor27@gmail.com>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tommi Rantala <tt.rantala@gmail.com>,
        Ted Mielczarek <ted@mielczarek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frank Razenberg <frank@zzattack.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        Petr Sebor <petr@scssoft.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I got your point... So having both looks like the best option to me.

2014-11-10 10:15 GMT-02:00 Daniel Dressler <danieru.dressler@gmail.com>:
> I'd love to make all controllers report as axises but doing so _will_
> break stuff downstream. Not least of which being every game which uses
> SDL2's controller configs:
> https://github.com/gabomdq/SDL_GameControllerDB/blob/master/gamecontrollerdb.txt
>
> Which is just about every-single major commercial proprietary game
> which has been ported to linux in the past 2 years.
>
> Now it should also be clear that adding extra axises will not break
> those games. The SDL2 library should just ignore those axises.
>
> Also, the module option "dpad_to_buttons" will only operate on unknown
> devices. Users cannot use it to return to old behavior so we have to
> get this right.
>
> Daniel
>
> 2014-11-10 20:47 GMT+09:00 Thomaz de Oliveira dos Reis <thor27@gmail.com>:
>> I totally agree that the behavior should be exactly the same in all
>> XBOX gamepads. But In my opinion this should be mapped as axis only,
>> since mapping for both could make a confusion in some games.
>>
>> If you need the axis to be buttons, you can set as a option while
>> loading the module.
>>
>>
>>
>>
>> 2014-11-10 6:06 GMT-02:00 Daniel Dressler <danieru.dressler@gmail.com>:
>>> Thanks Jon
>>>
>>> I've sent a second version of the patch without the TODO list edits.
>>>
>>>
>>> Now I would like to ask about a backwards compact issue related to this driver.
>>>
>>> Eons ago in patch 99de0912b [0] when support for the wireless 360
>>> controllers were added the decision was made to map their Dpad to the
>>> discrete buttons.
>>>
>>> There is reasonable justification for this behavior since the Dpad has
>>> never functioned like an analog stick on Xbox hardware.
>>>
>>> Except support for wired 360 controllers had been added a year earlier
>>> and used the opposite behavior. In fact the wireless 360 controllers
>>> are the only controllers which use the dpad_to_button behavior.
>>>
>>> Original Xbox, wired Xbox 360, and all Xbox One controllers all expose
>>> the dpad as a set of axises.
>>>
>>> This has caused pain for downstream developers. It means two
>>> controllers  have wildly different behavior. Many developers have just
>>> ignored the issue or suggested users unload xpand and use the userland
>>> replacement. Even Arch's wiki suggests such [1]. Which to be honest is
>>> all one can do. The xpad driver does not expose the information
>>> developers need to even incorporate a workaround without nasty hacks.
>>>
>>> As a downstream developer I've been bitten by this twice. The first
>>> time I didn't even know that wired vs wireless made a difference and I
>>> was disturbed to learn the truth.
>>>
>>> So here is what I want to hear opinions on: should the wireless 360's
>>> dpad be exposed as both axises _and_ buttons?
>>>
>>> [0]: https://github.com/torvalds/linux/commit/99de0912b when t
>>> [1]: https://wiki.archlinux.org/index.php/joystick#Xbox_360_controllers
>>>
>>> Daniel
>>>
>>> 2014-11-08 3:48 GMT+09:00 Jonathan Corbet <corbet@lwn.net>:
>>>> On Mon,  3 Nov 2014 17:53:06 +0900
>>>> Daniel Dressler <danieru.dressler@gmail.com> wrote:
>>>>
>>>>> The last time this documentation was accurate was
>>>>> just over 8 years ago. In this time we've added
>>>>> support for two new generations of Xbox console
>>>>> controllers and dozens of third-party controllers.
>>>>>
>>>>> This patch unifies terminology and makes it explicit
>>>>> which model of controller a sentence refers to.
>>>>
>>>> So this seems like a useful update, and I was looking at pulling it into
>>>> the docs tree.  But this hunk:
>>>>
>>>>> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
>>>>> index 2ed7905..7e2e047 100644
>>>>> --- a/drivers/input/joystick/xpad.c
>>>>> +++ b/drivers/input/joystick/xpad.c
>>>>> @@ -40,8 +40,8 @@
>>>>>   *
>>>>>   * TODO:
>>>>>   *  - fine tune axes (especially trigger axes)
>>>>> - *  - fix "analog" buttons (reported as digital now)
>>>>> - *  - get rumble working
>>>>> + *  - add original xbox rumble pack support
>>>>> + *  - add xbox one rumble support
>>>>>   *  - need USB IDs for other dance pads
>>>>>   *
>>>>>   * History:
>>>>
>>>> Seems like a different change that shouldn't be mixed up with the doc
>>>> update.  Send me a version without that change and, in the absence
>>>> of complaints, I'll apply it.
>>>>
>>>> Thanks,
>>>>
>>>> jon
