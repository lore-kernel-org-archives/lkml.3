Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaLSJG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:06:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37261 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaLSJGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:06:23 -0500
Message-ID: <5493EA88.1080609@ti.com>
Date: Fri, 19 Dec 2014 11:06:16 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>, <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>
CC: <t-kristo@ti.com>, <nm@ti.com>, <nsekhar@ti.com>, <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <5493B5CE.7010000@ti.com>
In-Reply-To: <5493B5CE.7010000@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lokesh,

On 19/12/14 07:21, Lokesh Vutla wrote:
> Hi Roger,
> On Thursday 18 December 2014 09:22 PM, Roger Quadros wrote:
>> Fixing up Paul's email id.
>>
>> cheers,
>> -roger
>>
>> On 18/12/14 17:49, Roger Quadros wrote:
>>> There are quite a few hwmods that don't have sysconfig register and so
>>> _find_mpu_rt_port(oh) will return NULL thus preventing ready state check
>>> on those modules after the module is enabled.
>>>
>>> This can potentially cause a bus access error if the module is accessed
>>> before the module is ready.
>>>
>>> Get rid of the redundant _find_mpu_rt_port() check from the _wait_target_ready()
>>> funcion for all the SoCs. The following PRCM register access that checks the
>>> module ready state has nothing to do with module's SYSCONFIG or mpu_rt_port.
> Yes, makes sense. This patch looks good to me.
> Tested this on AM437x-gp-evm.
> 
> Tested-by: Lokesh Vutla <lokeshvutla@ti.com>

Thanks.

> 
> May be good idea to warn every time if enabling of module is failed?
> Unrelated to this patch though.

Yes, failing to be ready is serious enough for a warning. Care to send a separate patch for that?

cheers,
-roger

