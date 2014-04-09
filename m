Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbaDIGHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:07:43 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62231 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbaDIGHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:07:39 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
In-Reply-To: <CAPM=9tyKKn5VrQkwGY2kEVBatSTN5VqJCVXWqFhn4oDe=oqsqA@mail.gmail.com>
References: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
	<878urg9ttv.fsf@intel.com>
	<CAMVG2suG7ysnci25Cy_+fzvQ8r_R9O2nCuVZf=Zw9t5ZvEOSLQ@mail.gmail.com>
	<CAPM=9tyKKn5VrQkwGY2kEVBatSTN5VqJCVXWqFhn4oDe=oqsqA@mail.gmail.com>
Date: Wed, 9 Apr 2014 14:07:38 +0800
Message-ID: <CAMVG2stTR=qadOYTMaCnGwLv6pUF9R2VeNVdhnRTw6Gki=FNHA@mail.gmail.com>
Subject: Re: [Intel-gfx] i915 DVI resolution regression (3.13.7+)
From: Daniel J Blueman <daniel@quora.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 11:41, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Apr 8, 2014 at 5:32 PM, Daniel J Blueman <daniel@quora.org> wrote:
>> On 8 April 2014 15:14, Jani Nikula <jani.nikula@linux.intel.com> wrote:
>>> On Tue, 08 Apr 2014, Daniel J Blueman <daniel@quora.org> wrote:
>>>> Ville et al,
>>>>
>>>> It looks like commit e3ea8fa6beaf55fee64bf816f3b8a80ad733b2c2 (or
>>>> another commit in 3.13.7) broke modes which require DVI-D dual-link,
>>>> eg 2560x1440 with my panel.
>>>>
>>>> I don't see these modelines in 3.13.7 or later (eg 3.14):
>>>>
>>>> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
>>>> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
>>>> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
>>>> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
>>>> [     5.582] (II) intel(0): Modeline "1920x1200"x59.9  193.25  1920
>>>> 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)
>>>>
>>>> My monitor is a Dell U2713HM; mobo uses an H87 chipset with i5-4670.
>>>
>>> By allowing those modes we regressed setups which were not capable of
>>> displaying them. So you've got an HDMI->DVI converter?
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=72961
>>
>> I am using a dual-link DVI-D to DVI-D cable to this monitor, since I
>> previously couldn't get 2560x1440 via HDMI.
>
> Intel hw has dual-link DVI-D? I'm not sure I've ever seen that, is
> this SDVO device or plain DVI-D?

It's the DVI-D connector on: https://www.asus.com/Motherboards/H87IPLUS/

However, it is logically detected as HDMI-0:

$ xrandr
Screen 0: minimum 320 x 320, current 2560 x 1440, maximum 32767 x 32767
VGA-0 disconnected (normal left inverted right x axis y axis)
HDMI-0 connected primary 2560x1440+0+0 (normal left inverted right x
axis y axis) 600mm x 340mm
   2560x1440      60.0*+
   1920x1200      59.9
   1920x1080      60.0
   1600x1200      59.9
   1680x1050      59.9
   1280x1024      74.9     59.9
   1280x800       59.8
   1152x864       74.8
   1024x768       74.9     59.9
   800x600        74.9     60.3
   640x480        74.8     59.4
   720x400        69.8
HDMI-1 disconnected (normal left inverted right x axis y axis)

Using the mobo HDMI socket and a HDMI to dual-link DVI-D cable
(logically detected as HDMI-1), the same patch causes the same issue.

Thanks,
  Daniel
-- 
Daniel J Blueman
