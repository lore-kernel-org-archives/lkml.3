Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaDOG1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:27:44 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:52183 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDOG1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:27:42 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
In-Reply-To: <87lhvf7zfv.fsf@intel.com>
References: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
	<878urg9ttv.fsf@intel.com>
	<CAMVG2suG7ysnci25Cy_+fzvQ8r_R9O2nCuVZf=Zw9t5ZvEOSLQ@mail.gmail.com>
	<CAPM=9tyKKn5VrQkwGY2kEVBatSTN5VqJCVXWqFhn4oDe=oqsqA@mail.gmail.com>
	<CAMVG2stTR=qadOYTMaCnGwLv6pUF9R2VeNVdhnRTw6Gki=FNHA@mail.gmail.com>
	<CAPM=9tz+xo7vktTZ=8QB6rMGPnTXd485wbwaq_4Ao9fGEnh4hQ@mail.gmail.com>
	<87lhvf7zfv.fsf@intel.com>
Date: Tue, 15 Apr 2014 14:27:41 +0800
Message-ID: <CAMVG2ssR82hTjofuFpLMt87-VW0iNN_JvoMCTaqRnoYFPSsGqg@mail.gmail.com>
Subject: Re: [Intel-gfx] i915 DVI resolution regression (3.13.7+)
From: Daniel J Blueman <daniel@quora.org>
To: Jani Nikula <jani.nikula@linux.intel.com>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 15:08, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> On Wed, 09 Apr 2014, Dave Airlie <airlied@gmail.com> wrote:
>> On Wed, Apr 9, 2014 at 4:07 PM, Daniel J Blueman <daniel@quora.org> wrote:
>>> On 9 April 2014 11:41, Dave Airlie <airlied@gmail.com> wrote:
>>>> On Tue, Apr 8, 2014 at 5:32 PM, Daniel J Blueman <daniel@quora.org> wrote:
>>>>> On 8 April 2014 15:14, Jani Nikula <jani.nikula@linux.intel.com> wrote:
>>>>>> On Tue, 08 Apr 2014, Daniel J Blueman <daniel@quora.org> wrote:
>>>>>>> Ville et al,
>>>>>>>
>>>>>>> It looks like commit e3ea8fa6beaf55fee64bf816f3b8a80ad733b2c2 (or
>>>>>>> another commit in 3.13.7) broke modes which require DVI-D dual-link,
>>>>>>> eg 2560x1440 with my panel.
>>>>>>>
>>>>>>> I don't see these modelines in 3.13.7 or later (eg 3.14):
>>>>>>>
>>>>>>> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
>>>>>>> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
>>>>>>> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
>>>>>>> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
>>>>>>> [     5.582] (II) intel(0): Modeline "1920x1200"x59.9  193.25  1920
>>>>>>> 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)
>>>>>>>
>>>>>>> My monitor is a Dell U2713HM; mobo uses an H87 chipset with i5-4670.
>>>>>>
>>>>>> By allowing those modes we regressed setups which were not capable of
>>>>>> displaying them. So you've got an HDMI->DVI converter?
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=72961
>>>>>
>>>>> I am using a dual-link DVI-D to DVI-D cable to this monitor, since I
>>>>> previously couldn't get 2560x1440 via HDMI.
>>>>
>>>> Intel hw has dual-link DVI-D? I'm not sure I've ever seen that, is
>>>> this SDVO device or plain DVI-D?
>>>
>>> It's the DVI-D connector on: https://www.asus.com/Motherboards/H87IPLUS/
>>
>> The link which says "
>>
>> Integrated Graphics Processor
>> - Supports HDMI with max. resolution 4096 x 2304 @ 24 Hz
>> - Supports DVI with max. resolution 1920 x 1200 @ 60 Hz
>> - Supports RGB with max. resolution 1920 x 1200 @ 60 Hz
>>
>> I'm even wondering electrically how a HDMI->dual-link DVI adapter works.
>
> The current assumption is that in the working case, they are really
> operated in single-link, with a frequency beyond the single-link DVI
> cable spec.

I checked with a single link DVI-D cable, and see the same behaviour
as with a dual link cable. This would have had to be driven out of
spec to achieve the resolution and refresh rate of my panel. That
said, the spec is old and the shielding on the dual-link cable
supplied with the panel is way over-specced.

If Intel GPUs (such as my Haswell board here) don't support dual-link
DVI, then this patch will prevent using panels >1920x1200 unless they
advertise low-refresh rate modes. It looks like the panel
manufacturers assume dual-link will be available.

The lesser of the evils may be to allow reasonable out-of-spec
dotclocks, unless I'm missing something?
-- 
Daniel J Blueman
