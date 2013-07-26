Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab3GZWDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:03:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39431 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZWD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:03:27 -0400
Message-ID: <51F2F22B.500@wwwdotorg.org>
Date: Fri, 26 Jul 2013 16:03:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: palmas: Add DVFS mux setting
References: <1374871308-490-1-git-send-email-achew@nvidia.com> <51F2E74E.2060107@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A12740FB@HQMAIL03.nvidia.com> <51F2EC66.2080200@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A1274113@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763862A1274113@HQMAIL03.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 03:50 PM, Andrew Chew wrote:
>>>> How does this interact with the pinctrl driver that Laxman just sent
>>>> for Palmas?
>>>>
>>>> https://lkml.org/lkml/2013/7/26/141
>>>> [PATCH 0/2] pinctrl: palmas: add pincontrol driver
>>>
>>> Thanks for pointing this out.  Given this:
>>>
>>> +Optional properties:
>>> +- ti,palams-enable-dvfs1: Enable DVFS1. Configure pins for DVFS1 mode.
>>> +- ti,palams-enable-dvfs2: Enable DVFS2. Configure pins for DVFS2 mode.
>>>
>>> I think his work already encompasses what my patch is supposed to do.
>>>
>>> Abandoning this patch.
>>
>> OK, that's simple!
>>
>> Are the existing ti,mux-pad1/ti,mux-pad2 properties already in the binding
>> redundant with Laxman's pinctrl driver?
> 
> In linux-next (where I based my work), yes, those two properties already exist,
> and as far as I understand it, are redundant with Laxman's pinctrl driver.
> I expect those properties will go away with Laxman's pinctrl driver.

Except those properties have been there for many kernel revisions and
are an ABI and hence can't be removed, although I noticed that they got
renamed recently, and of course we aren't technically being strict about
this quite yet...

Re: the complete pinctrl driver: is anything outside the Palmas going to
need to reprogram the Palmas pinctrl HW at run-time? Are the functions
that can be routed to the pins just static configuration for PMIC
features, or might other generic (non-Palmas) drivers use those pins for
something? If not, perhaps it's be simpler to just add your ti,mux-pad3
property and be done.
