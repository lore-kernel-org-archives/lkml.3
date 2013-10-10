Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3JJAy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:54:27 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34810 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3JJAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:54:25 -0400
Message-ID: <5255FAB5.7080803@gmail.com>
Date: Thu, 10 Oct 2013 11:54:13 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [PATCH 1/2] i2c designware make SCL and SDA falling time configurable
References: <20130828153429.GB7066@ab42.lan> <1381244455-3836-1-git-send-email-romainba@abilis.com> <20131009075538.GQ3521@intel.com>
In-Reply-To: <20131009075538.GQ3521@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 18:55, Mika Westerberg wrote:
> On Tue, Oct 08, 2013 at 05:00:54PM +0200, Romain Baeriswyl wrote:
>>  static void __i2c_dw_enable(struct dw_i2c_dev *dev, bool enable)
>> @@ -286,6 +287,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>>  	u32 input_clock_khz;
>>  	u32 hcnt, lcnt;
>>  	u32 reg;
>> +	u32 sda_falling_time, scl_falling_time;
>>  
>>  	input_clock_khz = dev->get_clk_rate_khz(dev);
>>  
>> @@ -307,15 +309,25 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>>  
>>  	/* set standard and fast speed deviders for high/low periods */
>>  
>> +	if (dev->sda_falling_time)
>> +		sda_falling_time = dev->sda_falling_time;
>> +	else
>> +		sda_falling_time = 300; /* ns */
> 
> I think this looks better:
> 
> 	sda_falling_time = dev->sda_falling_time ? dev->sda_falling_time : 300;

You can also use the gcc-ism, which is a bit more concise:

	sda_falling_time = dev->sda_falling_time ?: 300;

~Ryan

