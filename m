Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaCXKAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:00:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20085 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaCXKAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:00:42 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-85-533002488f10
Date: Mon, 24 Mar 2014 11:00:32 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [RFC v3 0/5] cpufreq:LAB: Support for LAB governor.
Message-id: <20140324110032.7aeae15e@amdc2363>
In-reply-to: <CAKohpok1zBsX7n70r=geCOaP-9ONx2QdaUMK6cJeqhFrO1PkUg@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
 <CAKohpok1zBsX7n70r=geCOaP-9ONx2QdaUMK6cJeqhFrO1PkUg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAV0PJoNgg3Uf1Sw2zljPavG06Qe7
	RefZJ8wWbx5xW2x6fI3V4vKuOWwWn3uPMFrMOL+PyeJ24wo2izOnL7FarJ/xmsVi84SNbBYd
	yxgtNn71cODz2DnrLrvHnWt72Dw2L6n3WDftLbPHlqvtLB59W1YxenzeJBfAHsVlk5Kak1mW
	WqRvl8CVcWnbDraCd2IVH97rNjC+Euxi5OSQEDCROHh8BiOELSZx4d56ti5GLg4hgUWMEje+
	LWKFcH4xSmy+PpUVpIpFQFVi0vVdbCA2m4CexOe7T5m6GDk4RAS0JF7eTAWpZxb4wCLx5+1E
	sKnCAg4SJ3Y1MYPU8ALV79nPDxLmFAiWWH/sPNSyM4wSr749ZgJJ8AtISrT/+8EMcZGdxLlP
	G9hBbF4BQYkfk++xgNjMQLs2b2tihbDlJTavecs8gVFwFpKyWUjKZiEpW8DIvIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOJ6eSe1gXNlgcYhRgINRiYf3Q49+sBBrYllxZe4hRgkOZiUR
	3nIGg2Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjNmP
	Oc7s7tqzlY3topjLj4+X6wIOcj5tWN/Q+LZqtcivaS8T1C67zHvN6sWjl8v9Luih3O+MKKUu
	wSkftuwq6TnksHOTfv66Gyey7cvehEtyrd9QpLZln5jXhTkHG04s8sioeeQuwD5p6rMpm9fr
	OJ98ycmm+zFW64Azo319zKWMhff/sR3qmabEUpyRaKjFXFScCADV19zQowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 4 March 2014 15:57, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Despite this patch set is working and applicable on top of 3.14-rc5,
> > please regard it solely as a pure RFC.
> 
> Okay, I am trying to do a review here and because you have mentioned
> how different it is from the earlier versions, I am trying with a
> fresh mind. i.e. with zero memories of earlier discussions :)
> 
> LAB was: Legacy Application Boost ??

Yes, correct.

> 
> Probably mention that in your new threads as well, so that new readers
> know the details. Also, like other governors, just name it "boost"
> governor.

I think, that "LAB" name is with us for some time, so it would be a
pity to discard it.

> 
> > This patch provides support for LAB governor build on top of
> > ondemand. Previous version of LAB can be found here:
> > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >
> > LAB short reminder:
> >
> > LAB uses information about how many cores are in "idle" state (the
> > core idleness is represented as the value between 0 and 100) and
> > the overall load of the system (from 0 to 100) to decide about
> > frequency to be set. It is extremely useful with SoCs like
> > Exynos4412, which can set only one frequency for all cores.
> 
> Probably a description of how exactly these two values come into play
> would have been more interesting here for all. Always think of new
> followers of your patchset and so add all interesting things about it
> when you resend it.
> 
> If I remember well the logic was more or less like this:
> - More idle cores means run few running cores at high frequency
> - Less idle cores means don't run them at very high frequencies
> 
> Right?

This is correct. Also, the underlying SoC - Exynos4412 has 4 cores with
option to set frequency only on all of them.

> 
> What about making it as simple as:
> - changing the ondemand governor only instead of adding a new governor

My goal is to not touch the ondemand code. It has matured, so I would
like to leave it as it is.

> - Keeping the bahavior as is for all platforms not publishing boost
> frequencies

This is also done - you get the LAB configuration specified in the DT
for the particular platform/board.

> - If more cores are idle, enable switching to boost frequencies and
> take them into consideration all the time.

I'm not sure if I have understood you, but something like that is also
performed in the code.

> - If less cores are idle, disable boost frequencies..

As written above.

> 
> Lets discuss this first and then I will get into the very details of
> your implementation.

Discussion about above functionalities requires consulting the
implementation to be sure that our opinions are the same.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
