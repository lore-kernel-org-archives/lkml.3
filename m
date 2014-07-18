Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbaGRDc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:32:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56661 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaGRDcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:32:55 -0400
Message-ID: <53C89566.9020505@codeaurora.org>
Date: Thu, 17 Jul 2014 20:32:54 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: myungjoo.ham@samsung.com
CC: =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] PM / devfreq: Add possible_frequencies device attribute
References: <725805840.101171405558256488.JavaMail.weblogic@epmlwas01c>
In-Reply-To: <725805840.101171405558256488.JavaMail.weblogic@epmlwas01c>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 05:50 PM, MyungJoo Ham wrote:
> On Wed, Jul 16, 2014 at 12:01 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
>> Some devices use freq_table instead of OPP. For those devices, the
>> available_frequencies sysfs file shows up empty. So, add a
>> possible_frequencies attribute/syfs file that list all the possible
>> frequencies.
>>
>> For devices that use OPP, the output of this file will match
>> available_frequencies. It may change in the future to show all OPP
>> frequencies -- even the disabled ones.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> 
> Hi,
> 
> 
> Please add a documentation entry for this new ABI having a little justification and usage included.

Will do.

> 
> Plus, I am considering to move trans_stat along with this entry to somewhere such as .../stat/*
> (you don't need to take care of this.)

Ok.

> 
> Besides, as OPP seems becoming the standard as imagined when devfreq development started,
> soon, devfreq may require OPP unless the devfreq device has continuous frequencies.

I agree. Only one caveat with OPP is that if a device isn't using OPP to
do any voltage scaling, then it forces a voltage column with 0s. Also,
even if we make OPP mandatory, we'll still want trans_stats that
currently seem to depend on freq_table being populated. I was actually
planning on sending out more patches later that'll do a lot of stuff
automatically for devices with OPP. Like creating freq_table, etc.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
