Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab3IHXCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 19:02:39 -0400
Received: from mout1.fh-giessen.de ([212.201.18.42]:38098 "EHLO
	mout1.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3IHXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 19:02:38 -0400
Message-ID: <522D020C.6070402@mni.thm.de>
Date: Mon, 09 Sep 2013 01:02:36 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:26.0) Gecko/20100101 Thunderbird/26.0a1
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Ilia Mirkin <imirkin@alum.mit.edu>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] 3.12rc1-pre Nouveau? oops
References: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>	<1378675264-3005-1-git-send-email-tobias.johannes.klausmann@mni.thm.de>	<CAPM=9tyCOdzC1NYy7jt+zh3WOuzubaO3b8vwFVast9ec=BWOkA@mail.gmail.com>	<522CF3D1.2020303@mni.thm.de> <CAPM=9twkyQGbnPEerqCpJNfXxSRo1pw7MBvGMuz8zs1pQ+Fcng@mail.gmail.com>
In-Reply-To: <CAPM=9twkyQGbnPEerqCpJNfXxSRo1pw7MBvGMuz8zs1pQ+Fcng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09.09.2013 00:29, Dave Airlie wrote:
> On Mon, Sep 9, 2013 at 8:01 AM, Tobias Klausmann
> <tobias.johannes.klausmann@mni.thm.de> wrote:
>> On 08.09.2013 23:33, Dave Airlie wrote:
>>>>> Looks like you have Optimus (intel + nvidia), and the backtrace has
>>>>> runtime pm in it, which is something new Dave added for 3.12, adding
>>>>> him in explicitly. The simplest explanation is that disp->init is
>>>>> NULL. And it seems like there are no outputs from the earlier nouveau
>>>>> init prints. I guess that the call to nouveau_display_resume from
>>>>> nouveau_pmops_runtime_resume should be guarded by a if
>>>>> (dev->mode_config.num_crtc) like it is everywhere else.
>>>>>
>>>>>     -ilia
>>>> Your guess was right, this (hopefully attached patch) fixes it for me!
>>> Does it look like this one?
>>>
>>> Dave.
>> No, mine was quick and dirty, reverted it and took yours. But i'm a little
>> bit confused that this is a suspend/resume problem, i booted the kernel for
>> the first time while seeing the oops. But anyway i tested it and it works.
> It's runtime suspend/resume - so it turns the nvidia gpu off at boot since it
> isn't being used.
>
> you should see longer battery life.
> Dave.
Ah thanks for the explanation.
Can we see the state in /sys somewhere? I looked around but did not find 
something to determine the state?
/sys/bus/pci/drivers/nouveau/0000:01:00.0/drm/card0/power/runtime_status 
gives me "unsupported".
But i suspect thats because of nouveaus lack to properly reclock my 
nvidia gpu. Anyway i'm better of asking you for the right anyswer.
Thanks for your time,
Tobias
