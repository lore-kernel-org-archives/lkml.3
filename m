Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3E3M73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:59:29 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8763 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3E3M7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:59:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 30 May 2013 05:59:21 -0700
Message-ID: <51A74D70.5060303@nvidia.com>
Date: Thu, 30 May 2013 18:30:32 +0530
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
References: <1369911393-25747-1-git-send-email-kishon@ti.com> <20130530113247.GI5180@sirena.org.uk>
In-Reply-To: <20130530113247.GI5180@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Mark,

On Thursday 30 May 2013 05:02 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, May 30, 2013 at 04:26:33PM +0530, Kishon Vijay Abraham I wrote:
>
>> Only compile tested. Just sent a patch to get some comments
>> /ideas on how to handle such one off regulators.
>> to handle
> What's unclear or confusing?  This all looks really basic...

Palma have SMPS10 regulator which can generate two voltage level 3.75 
and 5V.
This SMPS10 has the two outputs OUT1 and OUT2 and having one input IN1.

SMPS10-OUT2 is always connected to SMPS10-IN1 via following logic:
- Through parasitic diode (no sw control)
- In bypass mode (bit  configuration is there to enable/disable Bypass)
- In Boost mode (bit configuration is there to enable/disable Boost mode)

SMPS10-OUT1 is connected to the SMPS10-OUT2 pin through Switch (SW 
control for enabling/disabling this switch).


So I think:
regualtor enable/disable, we should toggle the bit for SWITCH.
In STANDBY mode, it should be BYPASS disable and Boost disable.
In Idle/Normal mode, BYPASS enable and Boost disable.
In Fast mode, it should be bypass disable and Boost enable.


Kishon,
Do you agree here?

