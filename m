Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaIZQ01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:26:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34151 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbaIZQ0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:26:25 -0400
Message-ID: <5425938C.6070007@ti.com>
Date: Fri, 26 Sep 2014 11:25:48 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>	<1389658764-39199-5-git-send-email-s-anna@ti.com> <CAJAp7Oj-3ZxvN8o=rg8YeTiXYWyQ1iowgisdU1R5UcZeh4VmOQ@mail.gmail.com>
In-Reply-To: <CAJAp7Oj-3ZxvN8o=rg8YeTiXYWyQ1iowgisdU1R5UcZeh4VmOQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 09/26/2014 09:40 AM, Bjorn Andersson wrote:
> On Mon, Jan 13, 2014 at 4:19 PM, Suman Anna <s-anna@ti.com> wrote:
>> This patch adds three new OF helper functions to use/request
>> locks from a hwspinlock device instantiated through a
>> device-tree blob.
>>
> 
> Hi Ohad, Suman
> 
> I'm about to send out some patches that depends on this functionality,
> how do we move forward?
> 
> I still think it's wrong to not return -EPROBE_DEFER, but I much
> rather have the code returning NULL than not having it in the tree (we
> can always argue about it later...).
> 
> @Suman, do you remember if there was any other comments on the patch?

I have posted two further revisions of this series, the latest is v6
[1]. I added additional patches in v5 that added the concept of reserved
locks, and I have posted them as a separate RFC [2] for v6 so as to not
block the core DT support.

In anycase, the latest v6 version does not define the
of_hwspin_lock_request_specific() function anymore, and it is replaced
with of_hwspin_lock_get_id() function, based on Ohad's review comments
on v5, and I did add the support for -EPROBE_DEFER in this API, without
changing any of the existing return code conventions.

I am yet to receive any comments on v6, but that series should address
both your need for a probe deferral and Ohad's request to not change any
return types. Please give it a try and let me know if you have any comments.

regards
Suman

[1] http://marc.info/?l=linux-arm-kernel&m=141055365513902&w=2
[2] http://marc.info/?l=linux-arm-kernel&m=141055554214657&w=2

> 
> @Ohad, do you object merging Suman's patch in it's current form? I
> think it should still apply cleanly.
> 
> Regards,
> Bjorn
> 

