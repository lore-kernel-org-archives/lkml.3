Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3FATBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:01:41 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2151 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3FATBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:01:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 01 Jun 2013 12:01:35 -0700
Message-ID: <51AA456E.3030307@nvidia.com>
Date: Sun, 2 Jun 2013 00:33:10 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <1369911393-25747-1-git-send-email-kishon@ti.com> <20130530113247.GI5180@sirena.org.uk> <51A74D70.5060303@nvidia.com> <20130601184511.GC16790@sirena.org.uk>
In-Reply-To: <20130601184511.GC16790@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 June 2013 12:15 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, May 30, 2013 at 06:30:32PM +0530, Laxman Dewangan wrote:
>
>> Palma have SMPS10 regulator which can generate two voltage level
>> 3.75 and 5V.
>> This SMPS10 has the two outputs OUT1 and OUT2 and having one input IN1.
>> SMPS10-OUT2 is always connected to SMPS10-IN1 via following logic:
>> - Through parasitic diode (no sw control)
>> - In bypass mode (bit  configuration is there to enable/disable Bypass)
>> - In Boost mode (bit configuration is there to enable/disable Boost mode)
>> SMPS10-OUT1 is connected to the SMPS10-OUT2 pin through Switch (SW
>> control for enabling/disabling this switch).
>> So I think:
>> regualtor enable/disable, we should toggle the bit for SWITCH.
>> In STANDBY mode, it should be BYPASS disable and Boost disable.
>> In Idle/Normal mode, BYPASS enable and Boost disable.
>> In Fast mode, it should be bypass disable and Boost enable.
> No, that makes no sense at all to me.  Why do you think this maps onto
> the set mode API?  Modes are all about accuracy of regulation.

I mapped this to the regulation under different load, Fast mode is in 
heavy load and so boost enable, normal/idle mode for normal load and so 
bypass.


