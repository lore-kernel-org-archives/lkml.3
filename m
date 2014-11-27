Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaK0AY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:24:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaK0AY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:24:26 -0500
Message-ID: <54766F36.3050104@suse.de>
Date: Thu, 27 Nov 2014 01:24:22 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stuart Yoder <stuart.yoder@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "bhamciu1@freescale.com" <bhamciu1@freescale.com>,
        "R89243@freescale.com" <R89243@freescale.com>,
        Geoff Thorpe <Geoff.Thorpe@freescale.com>,
        "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>,
        Richard Schmitt <richard.schmitt@freescale.com>
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com> <5475A85E.1080204@suse.de> <CY1PR0301MB0748850351477C53D47A042087700@CY1PR0301MB0748.namprd03.prod.outlook.com>
In-Reply-To: <CY1PR0301MB0748850351477C53D47A042087700@CY1PR0301MB0748.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26.11.14 23:33, Stuart Yoder wrote:
> 
> 
>> -----Original Message-----
>> From: Alexander Graf [mailto:agraf@suse.de]
>> Sent: Wednesday, November 26, 2014 4:16 AM
>> To: Rivera Jose-B46482; gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org
>> Cc: Yoder Stuart-B08248; Phillips Kim-R1AAHA; Wood Scott-B07421; Hamciuc Bogdan-BHAMCIU1; Marginean
>> Alexandru-R89243; Thorpe Geoff-R01361; Sharma Bhupesh-B45370; Erez Nir-RM30794; Schmitt Richard-B43082
>> Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex APIs
>>
>>
>>
>> On 13.11.14 18:54, J. German Rivera wrote:
>>> APIs to access the Management Complex (MC) hardware
>>> module of Freescale LS2 SoCs. This patch includes
>>> APIs to check the MC firmware version and to manipulate
>>> DPRC objects in the MC.
>>>
>>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>>
>> [...]
>>
>>> diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c
>>> new file mode 100644
>>> index 0000000..40ae552
>>> --- /dev/null
>>> +++ b/drivers/bus/fsl-mc/dprc.c
>>> @@ -0,0 +1,933 @@
>>> +/* Copyright 2013-2014 Freescale Semiconductor Inc.
>>> +*
>>> +* Redistribution and use in source and binary forms, with or without
>>> +* modification, are permitted provided that the following conditions are met:
>>> +* * Redistributions of source code must retain the above copyright
>>> +* notice, this list of conditions and the following disclaimer.
>>> +* * Redistributions in binary form must reproduce the above copyright
>>> +* notice, this list of conditions and the following disclaimer in the
>>> +* documentation and/or other materials provided with the distribution.
>>> +* * Neither the name of the above-listed copyright holders nor the
>>> +* names of any contributors may be used to endorse or promote products
>>> +* derived from this software without specific prior written permission.
>>> +*
>>> +*
>>> +* ALTERNATIVELY, this software may be distributed under the terms of the
>>> +* GNU General Public License ("GPL") as published by the Free Software
>>> +* Foundation, either version 2 of that License or (at your option) any
>>> +* later version.
>>> +*
>>> +* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
>>> +* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
>>> +* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
>>> +* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
>>> +* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
>>> +* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
>>> +* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
>>> +* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
>>> +* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
>>> +* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
>>> +* POSSIBILITY OF SUCH DAMAGE.
>>> +*/
>>> +#include <linux/fsl/mc-sys.h>
>>> +#include <linux/fsl/mc-cmd.h>
>>> +#include <linux/fsl/dprc.h>
>>> +#include "dprc-cmd.h"
>>> +
>>> +int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
>>
>> This one is definitely a misnomer. It's a command that operates on the
>> MC object, not a DPRC object. Also it doesn't fetch a random
>> "container_id", it fetches the root container id.
> 
> It's not strictly the root container. It fetches the container/DPRC ID
> associated with the portal you are using.  A virtual machine would use
> it to fetch it's container ID.

So does every portal properly react to this call? Or do only container
portals react to it?

In fact, what does make the initial portal special? Who reacts to
DPMNG_CMDID_foo calls? Every DPRC or only the initial root?

>> Please move it and its definition to the files that operate on the MC
>> management interface.
> 
> Note, the binary interface opcode really is DPRC_CMDID_GET_CONT_ID.
> 
> We can request that the binary interface naming be changed, but wouldn't
> it be better to keep the functions separated by opcode type-- having
> DPRC_CMDID* opcode-based commands be in one file and DPMNG_CMDID* commands
> in a separate file?

It really depends on what the semantics are. If this is a call that's
only valid on the MC root, then it should belong there. If it's
available on every container portal, it should be part of dprc of course.


Alex
