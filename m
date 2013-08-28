Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3H1Sc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:32:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44715 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3H1Sc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:32:56 -0400
Message-ID: <521E4256.4070805@wwwdotorg.org>
Date: Wed, 28 Aug 2013 12:32:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH RFC v2 3/5] spmi: add generic SPMI controller binding
 documentation
References: <cover.1377202730.git.joshc@codeaurora.org> <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org> <5217DB0C.7000101@wwwdotorg.org> <20130827170120.GR4035@joshc.qualcomm.com> <521D2047.8030300@wwwdotorg.org> <20130828180025.GA808@joshc.qualcomm.com>
In-Reply-To: <20130828180025.GA808@joshc.qualcomm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 12:00 PM, Josh Cartwright wrote:
> On Tue, Aug 27, 2013 at 03:55:19PM -0600, Stephen Warren wrote:
>> On 08/27/2013 11:01 AM, Josh Cartwright wrote:
>> ...
>>> If we want to ensure for the generic bindings that we are fulling
>>> characterizing/describing the SPMI bus, then we'll additionally need to
>>> tackle an additional identified assumption:
>>>
>>>   4. One master per SPMI bus.  (The SPMI spec allows for up to 4
>>>      masters)
>>>
>>> On the Snapdragon 800 series, there exists only one software-controlled
>>> master, but it is conceivably possible to have a setup with two
>>> software-controlled masters on the same SPMI bus.
>>>
>>> This necessarily means that the description of the slaves and the
>>> masters will need to be decoupled; I'm imagining a generic binding
>>> supporting multiple masters would look something like this:
>>
>> Is there a need to represent the other masters in the DT? Sure they're
>> there in HW, but if there's no specific way for the
>> CPU-to-which-the-DT-applies to actually interact with those other
>> masters (except perhaps by experiencing some arbitration delays) then
>> presumably there's no need to represent the other masters in DT?
> 
> My example is contrived, but there is nothing in the SPMI spec
> preventing two masters from being controllable by the same
> CPU-to-which-the-DT-applies, sharing the same underlying bus.

That's true.

> I would also expect this configuration to be uncommon, I'm checking with
> some folks with more SPMI experience to make sure they agree.
> 
> Interestingly, i2c as far as I can tell has also made the same
> assumption.  There doesn't appear to be any way to express a
> multi-master i2c setup where both masters are controlled by the same OS.

Yes, I think it's a fair assumption that we don't need to represent
that; I immediately thought about the I2C counter-example after reading
your first paragraph.
