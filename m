Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaLRKF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:05:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24503 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLRKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:05:22 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-be-5492a6e0aa7f
Message-id: <5492A6DE.5020704@samsung.com>
Date: Thu, 18 Dec 2014 11:05:18 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Kevin Hilman <khilman@kernel.org>
Cc: amit daniel kachhap <amit.daniel@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v3 1/2] PM / Domains: Extend API
 pm_genpd_dev_need_restore to use restore types
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
 <CADGdYn4WQ6i29ecTthu7eNUfSSQ--YESGyHcA1_9CdK-h53hxA@mail.gmail.com>
 <7h4msub0ca.fsf@deeprootsystems.com> <5418986.E58ik2Q1Hm@vostro.rjw.lan>
In-reply-to: <5418986.E58ik2Q1Hm@vostro.rjw.lan>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xy7oPlk0KMZh8TMui4WqIxdzZkxgt
	ehdcZbN4uvkxk8WsKXuZLDY9vsZqcXnXHDaLz71HGC1mnN/HZLH2yF12i0Vbv7BbnDl9idWi
	Yxmjxapdfxgtjq8Nd+D3mHhW12PnrLvsHov3vGTy2LSqk83jzrU9bB6bl9R7bLnazuLRt2UV
	o8fnTXIBnFFcNimpOZllqUX6dglcGe3f+5kLTvBVXJm8lbmBcRd3FyMHh4SAicS2ryxdjJxA
	ppjEhXvr2boYuTiEBJYySvRf+ADlfGKUmHnyPytIFa+AlsTrfxOYQWwWAVWJo8cfsIHYbAKG
	Er1H+xhBbFGBCImTd/ewQ9QLSvyYfA9sg4iAn8S6NVeYQYYyC7xhkfh86x9Ys7BApkTbtW2s
	ENtuMEo8+/YErJtTwEBi8twTLCCnMguoS0yZkgsSZhaQl9i85i3zBEaBWUh2zEKomoWkagEj
	8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkJj6uoNx6TGrQ4wCHIxKPLwJuZNChFgTy4or
	cw8xSnAwK4nwRucAhXhTEiurUovy44tKc1KLDzEycXBKNTCWXeeIclHQ9Fi812OH0EXNEwbB
	L8r3pXJlqTU8kGDt6lOLN3Jwcrb2f3/E2aa2ID43a5KVj6ZdiNGXjAkuu1c+8Zprfcvh/tTP
	jW4Gfy3erlhn0LXnCHO1ce7CN8/WOTUqrMk0jjR7nfLI9W1sNNOXYLfrnIYMpxJnh2+/u3X7
	taPJ1xgTVyuxFGckGmoxFxUnAgC50WOKhwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/12/14 01:58, Rafael J. Wysocki wrote:
>>>> What's needed to solve this problem is a generalized way to have runtime
>>>> > >> PM dependencies between devices.  Runtime PM already automatically
>>>> > >> handles parent devices as one type of dependent device (e.g. a parent
>>>> > >> device needs to be runtime PM resumed before its child.)  So what's
>>>> > >> needed is a generic way to other PM dependencies with the runtime PM
>>>> > >> core (not the genpd core.)
>>> > >
>>> > > Considering the example above with three devices, device D1 and D2 are
>>> > > passive components in this power domain. These devices only need to
>>> > > know the state changes of the power domains but would not control the
>>> > > power domain themselves nor put forth constraints in the power domain
>>> > > state changes. So I did not clearly understand as to how this example
>>> > > could be solved by introducing changes in runtime PM core.
>> > 
>> > Your solution only solves the problems for devices managed by genpd.
>> > 
>> > If I understood your example correctly, what you really want to solve
>> > this problem more generically is to be able to tell the runtime PM core
>> > that D3 has a dependency on D1 and D2.  Then, whenver the runtime PM
>> > core is doing get/put operations for D3, it needs to also do them for D1
>> > and D2.

Indeed, I think it would solve most of the problems if we were able to
model the PM dependencies between devices which would then be handled
in the PM core.  I recall something like this has been proposed a while
ago [1].

>> > This will accomplish the same as your proposed approach, but work for
>> > any devices in any PM domains.
>
> Plus, it is not limited to runtime PM, really.  It affects system suspend
> too.

[1] https://lkml.org/lkml/2009/8/26/485

-- 
Regards,
Sylwester
