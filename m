Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069AbaDOFQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:16:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55794 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaDOFQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:16:11 -0400
Message-ID: <534CC09A.30200@codeaurora.org>
Date: Mon, 14 Apr 2014 22:16:10 -0700
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
Subject: Re: [PATCH] PM / devfreq: Use freq_table for available_frequencies
References: <8568895.444151397525760132.JavaMail.weblogic@epml02>
In-Reply-To: <8568895.444151397525760132.JavaMail.weblogic@epml02>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 06:36 PM, ÇÔ¸íÁÖ wrote:
>> MyungJoo/Kyungmin,
>>
>> Bump. Can we accept this patch please?
>>
>> -Saravana
> 
> Nack.
> 
> Please note that freq_table is also an optional value, which may
> be null.

Ah, I saw that the max_freq would be zero if freq_table was NULL and I
assumed that it can't be NULL. But I see that the max_freq limit is not
applied if it's zero. Thanks for catching it.

> Besides, please be aware that your code is under rcu_read_lock().

Valid point. I was just trying to keep the diff simple. No one's really
going to be catting this file often when performance matters.

> 
> 
> Cheers,
> MyungJoo.
> 
> ps. I'll send a related patch (avoid accessing null but not-an-error
> pointer at other sysfs nodes). Thank you for letting me catch such bugs anyway.

I can go ahead and do this myself if you don't mind.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
