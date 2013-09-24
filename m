Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3IXTtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:49:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33238 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3IXTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:49:39 -0400
Message-ID: <5241ECCC.3020808@wwwdotorg.org>
Date: Tue, 24 Sep 2013 13:49:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: srinivas.kandagatla@st.com
CC: linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: st-rc: Add ST remote control driver
References: <1379581176-25078-1-git-send-email-srinivas.kandagatla@st.com> <5240A740.7000407@wwwdotorg.org> <5241488F.5010000@st.com>
In-Reply-To: <5241488F.5010000@st.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 02:08 AM, Srinivas KANDAGATLA wrote:
> Thanks Stephen,
> On 23/09/13 21:40, Stephen Warren wrote:
>> On 09/19/2013 02:59 AM, Srinivas KANDAGATLA wrote:
>>> This patch adds support to ST RC driver, which is basically a IR/UHF
>>> receiver and transmitter. This IP (IRB) is common across all the ST
>>> parts for settop box platforms. IRB is embedded in ST COMMS IP block.
>>> It supports both Rx & Tx functionality.
>>>
>>> In this driver adds only Rx functionality via LIRC codec.
>>
>>> diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/media/st-rc.txt

>>> +	- rx-mode: can be "infrared" or "uhf". rx-mode should be present iff the
>>> +	  rx pins are wired up.
>>> +	- tx-mode: should be "infrared". tx-mode should be present iff the tx
>>> +	  pins are wired up.
>>
>> Should those property names be prefixed with "st,"; I assume they're
>> specific to this binding rather than something generic that applies to
>> all IR controller bindings? If you expect them to be generic, it's fine.
> 
> Officially these bindings are not specified in ePAPR specs

Well, there are plenty of properties we now consider generic that aren't
in ePAPR...

> but I see no reason for not having these properties as generic ones.
>
> Are you ok with that?

I suppose that infrared-vs-uhf is a concept that's probably common
enough across any similar HW device, so it may make sense for these
properties to be generic. If we do intend them to be generic, I'd
suggest they be defined in some generic binding document though; perhaps
something like bindings/media/ir.txt or
bindings/media/remote-control.txt? That way, a HW-specific binding isn't
the only place where a supposedly generic property is defined.
