Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3HLSAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:00:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51331 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3HLR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:59:57 -0400
Message-ID: <52092299.4080104@wwwdotorg.org>
Date: Mon, 12 Aug 2013 11:59:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/2] include: dt-binding: input: create a DT header defining
 key codes.
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com> <52014E50.6030508@wwwdotorg.org> <5203D138.4030107@nvidia.com> <20130808171331.GA6960@core.coreip.homeip.net> <5203D487.5020507@wwwdotorg.org> <20130812171504.GA31418@core.coreip.homeip.net>
In-Reply-To: <20130812171504.GA31418@core.coreip.homeip.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:15 AM, Dmitry Torokhov wrote:
> On Thu, Aug 08, 2013 at 11:25:27AM -0600, Stephen Warren wrote:
>> On 08/08/2013 11:13 AM, Dmitry Torokhov wrote:
>>> On Thu, Aug 08, 2013 at 10:41:20PM +0530, Laxman Dewangan wrote:
>>>> On Wednesday 07 August 2013 12:58 AM, Stephen Warren wrote:
>>>>> (CC'ing DT bindings maintainers too, hence quoting a bit of the patch)
>>>>>
>>>>> On 08/06/2013 08:12 AM, Laxman Dewangan wrote:
>>>>>> Many of Key device tree bindings uses the constant number as key code
>>>>>> which matches with kernel header key code and then comment as follows
>>>>>> for reference/better readability:
>>>>>> 	linux,code = <102>; /* KEY_HOME */
>>>>>>
>>>>>> Create a DT header which defines all the key code so that DT key bindings
>>>>>> can use it as follows:
>>>>>> 	linux,code = <KEY_HOME>;
>> ...
>>> I am uncomfortable that we are duplicating the whole list of keycodes
>>> here. Do you think we could split keycodes and other event codes from
>>> include/uapi/linux/input.h into include/uapi/linux/input-events.h and
>>> unclude it directly into DTS?
>>
>> Device tree files can only include headers in include/dt-bindings.
>> Eventually/soon, all the DT files and the headers in the dt-bindings/
>> directory will be split out into a separate git tree, which does not
>> have access to include/uapi, or indeed any other Linux kernel header files.
> 
> OK, that makes it easier for me - please merge through whatever tree
> that owns include/dt-bindings.

Are there any objections to my taking both patches through the Tegra
tree? Patch 2/2 depends on 1/2 and is Tegra-specific. This should work
out fine unless anyone else wants to use the new header this kernel
cycle; if they do, this should go into a topic branch in the DT tree
that I can pull into the Tegra tree.
