Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaENO1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:27:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52050 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbaENO1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:27:13 -0400
Message-ID: <53737D34.5040307@ti.com>
Date: Wed, 14 May 2014 09:27:00 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Chander Kashyap <chander.kashyap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>	<CAGo_u6qTZ-yq26+K5nHut92d=-9nrCHKDNK9EMLK5kGMQc+dOw@mail.gmail.com>	<CANuQgHGehqDD8-SKTfEKMEZmT5KwofFL8bhYqge0uNm6kpPgUQ@mail.gmail.com> <CAKohponfdoPG7H4h-5s+V7CwB_SgnyqqUm9aa6G-K_cX3DOcfA@mail.gmail.com>
In-Reply-To: <CAKohponfdoPG7H4h-5s+V7CwB_SgnyqqUm9aa6G-K_cX3DOcfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:08 AM, Viresh Kumar wrote:
> On 14 May 2014 15:01, Chander Kashyap <chander.kashyap@linaro.org> wrote:
>>> say we do at this point:
>>> if (new_opp->rate == opp->rate) {
>>>   dev_err(dev, "%s: attempt to add duplicate OPP entry (rate=%ld)\n",
>>> __func__, new_opp->rate)
>>>    kfree(new_opp);
>>>     return -EINVAL;
>>> }
>>
>> Yes this is more cleaner.
>> But instead of dev_err,  we should use dev_warn and secondly
> 
> Correct
> 
>> return 0 rather than EINVAL, as there are independent users for this function
> 
> Why? We should actually use EEXIST here instead of EINVAL though..
> 
Yep -EEXIST is the right return value here. As Viresh indicated,
reporting back 0 when the requested operation actually was not
performed is wrong. Caller is supposed to know when it makes an error
- hiding it is not correct.

-- 
Regards,
Nishanth Menon
