Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3HZDin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:38:43 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:51424 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HZDim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <521AAFDF.9090608@samsung.com>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
	<1377188348-3418-3-git-send-email-dianders@chromium.org>
	<521761F1.60203@samsung.com>
	<CAD=FV=WrZacm7UUB3-qE=ufwkur_55m0puPNdUaGBYszPw9OdQ@mail.gmail.com>
	<521AAFDF.9090608@samsung.com>
Date: Sun, 25 Aug 2013 20:38:41 -0700
X-Google-Sender-Auth: txaQWwzbBkkpmOJUjITO1mp--rg
Message-ID: <CAD=FV=XL-J700CBgwgWfy6JNKL9rNcbPNsqXH=--kGsNJJPS2Q@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Sun, Aug 25, 2013 at 6:31 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Doug,
>
> On 08/24/2013 05:40 AM, Doug Anderson wrote:
>> Jaehoon,
>>
>> On Fri, Aug 23, 2013 at 6:21 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi Doug,
>>>
>>> If the clock-gating is enabled, then maybe it's continuously printed the kernel message for Bus_speed.
>>
>> Can you explain?  I don't think dw_mmc has support for clock gating
>> right now.  ...or are there some patches that I'm not aware of?  I
>> could believe that if you've got some non-upstream clock gating
>> patches that these would need to be modified to handle it...  ...but
>> unless those are slated to land upstream it seems like I can't take
>> them into account, can I?
> If i enabled the CONFIG_MMC_CLK_GATE, the i have found the below message whenever some operation is run.
> I will test more with your patch.

Ah, sorry!  I wasn't aware of that config option.  I was thinking of
automatic clock gating based on something like the common clock
framework.  When there are no more users of a gate clock it will get
turned off.  To have that work dw_mmc would need to release its biu /
ciu clocks at some point.

If I had to guess, I'd speculate that perhaps we should just change
the printout to a dev_debug(), though I do find that printout
incredibly useful.  If I had to guess I'd say that the mmc core is
switching between a clock of 0 and a full speed clock constantly.  If
that's true then it means that dw_mmc used to treat that like a no-op.
 Now it actually gates the clock.  If you comment out the printout, do
things still work?  Does your power consumption go down?

Let me know if you find anything.  Otherwise I can try to reproduce this week.

-Doug
