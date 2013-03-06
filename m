Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3CFIhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:37:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1487 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3CFIhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:37:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Mar 2013 00:31:45 -0800
Message-ID: <51370056.3040508@nvidia.com>
Date: Wed, 6 Mar 2013 17:37:42 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable regulator
References: <1362527485-8611-1-git-send-email-achew@nvidia.com> <5136A781.2050303@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629BFE1DB7@HQMAIL03.nvidia.com> <5136CBC7.3030803@nvidia.com> <20130306070019.GA2436@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130306070019.GA2436@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 04:00 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Mar 06, 2013 at 01:53:27PM +0900, Alex Courbot wrote:
>> On 03/06/2013 11:41 AM, Andrew Chew wrote:
>>>>>    struct pwm_bl_data {
>>>>>    	struct pwm_device	*pwm;
>>>>>    	struct device		*dev;
>>>>> +	struct regulator	*en_supply;
>>>>> +	bool			en_supply_enabled;
>>>>
>>>> Couldn't you use regulator_is_enabled() and get rid of en_supply_enabled?
>>>> It would also ensure the driver performs correctly no matter what the initial
>>>> state of the regulator is.
>>>
>>> Are you sure this works?  I'm concerned about the (bizarre and unlikely) case
>>> where this supply is shared with another driver, so I use en_supply_enabled
>>> to track the state of the supply such that I can ignore that case.
>>
>> You're right, consumers can share regulators and the calls to
>> enable/disable need to be balanced. Also there is no way to check
>> the intensity of the backlight prior to the change to detect a
>> transition, so I guess your approach is indeed the most appropriate
>> here.
>
> I think the right thing to do here is just enable the regulator when
> the pwm-backlight driver needs it. If it is shared with other devices
> they'll have to do the same and the reference counting should only
> disable the regulator when there are no users.
 >
> Tracking this via platform data won't work because platform data is
> statically defined at compile time. So if indeed there was another user
> of the regulator it enable/disable the regulator at any time and your
> en_supply_enabled would be wrong.

Oh wait. I thought regulator_enable/disable calls needed to be balanced, 
is that not the case? So every consumer receives a different regulator 
handle in case of a shared regulator, which becomes disabled if all 
handles are disabled? In that case yes, we won't have to bother about a 
status variable here and balancing calls. Sorry for the confusion.

Alex.

