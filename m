Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaBNTKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:10:22 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:57799 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBNTKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZtviRCtaC4-3_ubkYuEt+LYstwbi6qus-5GOoOLYhfecw@mail.gmail.com>
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
	<52FCFD92.7040109@hurleysoftware.com>
	<s5hiosi3osp.wl%tiwai@suse.de>
	<CAAJw_ZsoO=kd6cVM3HYrkim5K0RKrnDXYGgodNNQmHVYs19a8A@mail.gmail.com>
	<s5hha8123vu.wl%tiwai@suse.de>
	<CAAJw_ZtviRCtaC4-3_ubkYuEt+LYstwbi6qus-5GOoOLYhfecw@mail.gmail.com>
Date: Fri, 14 Feb 2014 11:10:16 -0800
Message-ID: <CAKbGBLjGEC5d6LQ-JpxFr=aDZCmtY98HK7T0wN_mqmaWu1juZA@mail.gmail.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
From: Steven Noonan <steven@uplinklabs.net>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Peter Hurley <peter@hurleysoftware.com>,
        lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:01 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Fri, Feb 14, 2014 at 9:57 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> The other possible change in hda_intel.c is the enablement of runtime
>> PM for Panther Point.  But it's been working for other chips, so
>> wondering why it hits anything.  In anyway, please give the full
>> Oops messages not only the stack trace.
>
>> Any difference in the sound hardware, i.e. PCI controller and codec
>> chips?
>
> # X230 reported the sound card as:
> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
> Family High Definition Audio Controller (rev 04)
> == HDA Intel PCH, ALC269VC Analog
>
> # X240 reported the sound card as:
> 00:1b.0 Audio device: Intel Corporation Lynx Point-LP HD Audio
> Controller (rev 04)
> ==  HDA Intel PCH, ALC292 Analog
>
> Now I managed to make suspend-to-ram work by using sound as module
> instead of build-in.
>
> Here's the difference ...
>
> # bad
> CONFIG_SND_HDA_CODEC_HDMI =y
> CONFIG_SND_HDA_INTEL=y
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_CODEC_HDMI=y
> CONFIG_SND_HDA_GENERIC=y
>
>
> # good
> CONFIG_SND_HDA_CODEC_HDMI =m
> CONFIG_SND_HDA_INTEL=m
> CONFIG_SND_HDA_INPUT_BEEP=m
> CONFIG_SND_HDA_CODEC_HDMI=m
> CONFIG_SND_HDA_GENERIC=m
>
>
> Strange?
>
> Jeff

Of those modules, which are loaded? If you load all of them and then
try to suspend, does it still work?
