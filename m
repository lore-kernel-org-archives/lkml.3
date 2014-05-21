Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaEUO7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:59:22 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39534 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaEUO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <537CBB4C.7000006@arm.com>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
	<b59df199b373191791afcccd627d900ce07afa71.1400670427.git.viresh.kumar@linaro.org>
	<537CADFB.1090305@arm.com>
	<CAKohpo=-kmfH9Z+m8E9HQXs4AvRoUCDzcrns6-HHLH=AqeJ-DQ@mail.gmail.com>
	<537CBB4C.7000006@arm.com>
Date: Wed, 21 May 2014 20:29:18 +0530
Message-ID: <CAKohpo=tQeCkc9AzyCPbuDnkB-+YgStechwaCg6R0-zEVgF3Rg@mail.gmail.com>
Subject: Re: [PATCH V2 3/7] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 20:12, Sudeep Holla <sudeep.holla@arm.com> wrote:
> Hmm agreed, but there are SoCs that support per CPU DVFS ;)

Lets see what's Nishanth/Rafael's view on this. I am more or less in
favor of it. But isn't a big thing. Can convert it to dbg if it annoys you :)

>> Probably we will call of_init_opp_table() directly for other devices, as
>> this
>> function doesn't do anything else, apart from some prints.. So, probably
>> leave is as is for now, unless a real need arises ?

> I don't see anything cpu specific there, but that's just my opinion.

I never said that it has anything cpu specific.. What I said was that this
routine wouldn't have existed if Rafael wouldn't have asked for it. It is
just a wrapper over of_init_opp_table, which also has a dummy
implementation when its not supported.

So, it might not be worth enough for any other code to use it. :)
But in case it is, we can add it later.
