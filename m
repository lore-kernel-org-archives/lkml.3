Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3JMLhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:37:09 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:41923 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab3JMLhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=amkrpI
	0ICEM8dBsfK8zWNetaiKjdgWkNxuuGdSJv1MaMNmINrJ1dOqhztvUYcjLPyzhGTV
	5O8DAhjHFfO46kaucVWmsSjPb9ZA614hOYHTOFeMEqYXgn9M3zMVUv6XPXC7yjtz
	ppd1OC5a9fz1oG3ib3ZRtE2vPzlKIcxbVci84=
Message-ID: <525A85D6.3090608@pobox.com>
Date: Sun, 13 Oct 2013 20:36:54 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: rmallon@gmail.com, mika.westerberg@linux.intel.com,
        Romain.Baeriswyl@abilis.com
CC: wsa@the-dreams.de, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        pierrick.hascoet@abilis.com, vgupta@synopsys.com,
        christian.ruppert@abilis.com, chiau.ee.chew@intel.com,
        khali@linux-fr.org, rafael.j.wysocki@intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        romainba@abilis.com
Subject: Re: [PATCH 1/2] i2c designware make SCL and SDA falling time configurable
References: <20130828153429.GB7066@ab42.lan> <1381244455-3836-1-git-send-email-romainba@abilis.com> <20131009075538.GQ3521@intel.com> <5255FAB5.7080803@gmail.com>
In-Reply-To: <5255FAB5.7080803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: C642CB30-33FB-11E3-914A-8F264F2CC097-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/13 9:54 AM, Ryan Mallon wrote:
> On 09/10/13 18:55, Mika Westerberg wrote:
>> On Tue, Oct 08, 2013 at 05:00:54PM +0200, Romain Baeriswyl wrote:
>>> @@ -307,15 +309,25 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>>>
>>>   	/* set standard and fast speed deviders for high/low periods */
>>>
>>> +	if (dev->sda_falling_time)
>>> +		sda_falling_time = dev->sda_falling_time;
>>> +	else
>>> +		sda_falling_time = 300; /* ns */
>>
>> I think this looks better:
>>
>> 	sda_falling_time = dev->sda_falling_time ? dev->sda_falling_time : 300;
>
> You can also use the gcc-ism, which is a bit more concise:
>
> 	sda_falling_time = dev->sda_falling_time ?: 300;

+1

