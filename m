Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaJXFDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:03:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46529 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaJXFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:03:09 -0400
Date: Fri, 24 Oct 2014 01:03:06 -0400 (EDT)
Message-Id: <20141024.010306.1939269479587208896.davem@davemloft.net>
To: linux@roeck-us.net
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
From: David Miller <davem@davemloft.net>
In-Reply-To: <54488CE1.2000106@roeck-us.net>
References: <1414037002-25528-7-git-send-email-linux@roeck-us.net>
	<CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
	<54488CE1.2000106@roeck-us.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 22:03:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Wed, 22 Oct 2014 22:06:41 -0700

> On 10/22/2014 09:37 PM, Florian Fainelli wrote:
>> 2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
>>> Some Marvell switches provide chip temperature data.
>>> Add support for reporting it to the dsa infrastructure.
>>>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>> [snip]
>>
>>> +/* hwmon support
>>> ************************************************************/
>>> +
>>> +#if defined(CONFIG_HWMON) || (defined(MODULE) &&
>>> defined(CONFIG_HWMON_MODULE))
>>
>> IS_ENABLED(CONFIG_HWMON)?
>>
> 
> Hi Florian,
> 
> unfortunately, that won't work; I had it initially and got a nice
> error message
> from Fengguang's build test bot.

Then the Kconfig dependencies are broken.

Fix Kconfig to only allow legal combinations.
