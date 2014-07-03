Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaGCJMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:12:35 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61065 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGCJMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:12:33 -0400
Message-ID: <53B51E68.7090308@linaro.org>
Date: Thu, 03 Jul 2014 10:12:08 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mathieu Poirier <mathieu.poirier@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9 v2] coresight: add CoreSight core layer framework
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>	<1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>	<53B3D2F9.2030009@linaro.org> <CANLsYkxKZvb4cOeEfwFB8CbK_PKy6daPL63L00Sx=NvtDjGbfw@mail.gmail.com>
In-Reply-To: <CANLsYkxKZvb4cOeEfwFB8CbK_PKy6daPL63L00Sx=NvtDjGbfw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/14 20:06, Mathieu Poirier wrote:
>>> +struct dentry *cs_debugfs_parent = NULL;
>>> +
>>> +static int curr_sink = NO_SINK;
>>> +static LIST_HEAD(coresight_orph_conns);
>>> +static LIST_HEAD(coresight_devs);
>>> +static DEFINE_SEMAPHORE(coresight_mutex);
>>
>> Why is coresight_mutex a semaphore?
> 
> Bad naming convention.

Really? I only saw it used like a mutex, in other words I thought it was
incorrectly typed, rather than incorrectly named.


>>> +static void coresight_disable_link(struct coresight_device *csdev)
>>> +{
>>> +     int link_subtype;
>>> +     int refport, inport, outport;
>>> +
>>> +     inport = coresight_find_link_inport(csdev);
>>> +     outport = coresight_find_link_outport(csdev);
>>> +
>>> +     link_subtype = csdev->subtype.link_subtype;
>>> +     if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
>>> +             refport = inport;
>>> +     else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
>>> +             refport = outport;
>>> +     else
>>> +             refport = 0;
>>
>> I already read these 7 lines once...
> 
> It is really worth spinning off a function to save 5 lines?

Pretty marginal really. If the code here stays as it is I don't care
enough to raise this point a second time.


Daniel.
