Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab3IHW3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 18:29:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61732 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IHW3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 18:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <522CF3D1.2020303@mni.thm.de>
References: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>
	<1378675264-3005-1-git-send-email-tobias.johannes.klausmann@mni.thm.de>
	<CAPM=9tyCOdzC1NYy7jt+zh3WOuzubaO3b8vwFVast9ec=BWOkA@mail.gmail.com>
	<522CF3D1.2020303@mni.thm.de>
Date: Mon, 9 Sep 2013 08:29:05 +1000
Message-ID: <CAPM=9twkyQGbnPEerqCpJNfXxSRo1pw7MBvGMuz8zs1pQ+Fcng@mail.gmail.com>
Subject: Re: [Nouveau] 3.12rc1-pre Nouveau? oops
From: Dave Airlie <airlied@gmail.com>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Dave Airlie <airlied@linux.ie>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 8:01 AM, Tobias Klausmann
<tobias.johannes.klausmann@mni.thm.de> wrote:
>
> On 08.09.2013 23:33, Dave Airlie wrote:
>>>>
>>>> Looks like you have Optimus (intel + nvidia), and the backtrace has
>>>> runtime pm in it, which is something new Dave added for 3.12, adding
>>>> him in explicitly. The simplest explanation is that disp->init is
>>>> NULL. And it seems like there are no outputs from the earlier nouveau
>>>> init prints. I guess that the call to nouveau_display_resume from
>>>> nouveau_pmops_runtime_resume should be guarded by a if
>>>> (dev->mode_config.num_crtc) like it is everywhere else.
>>>>
>>>>    -ilia
>>>
>>> Your guess was right, this (hopefully attached patch) fixes it for me!
>>
>> Does it look like this one?
>>
>> Dave.
>
> No, mine was quick and dirty, reverted it and took yours. But i'm a little
> bit confused that this is a suspend/resume problem, i booted the kernel for
> the first time while seeing the oops. But anyway i tested it and it works.

It's runtime suspend/resume - so it turns the nvidia gpu off at boot since it
isn't being used.

you should see longer battery life.
Dave.
