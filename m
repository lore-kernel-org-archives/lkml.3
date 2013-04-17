Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920Ab3DQJN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:13:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:45019 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965887Ab3DQJNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:13:25 -0400
Message-ID: <516E67B2.20509@imgtec.com>
Date: Wed, 17 Apr 2013 10:13:22 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com> <515BD6B8.1020607@synopsys.com> <515C5652.8070705@wwwdotorg.org> <515D0FFB.4030803@synopsys.com> <515DBA0E.6000604@wwwdotorg.org> <51642158.3070205@synopsys.com> <5167BA67.5080403@synopsys.com> <5168822C.6040303@wwwdotorg.org> <516D7405.3060202@imgtec.com> <516E2169.4020007@synopsys.com>
In-Reply-To: <516E2169.4020007@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_17_10_13_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/13 05:13, Vineet Gupta wrote:
> Hi James,
> 
> On 04/16/2013 09:23 PM, James Hogan wrote:
>> On 12/04/13 22:52, Stephen Warren wrote:
>>> +.SECONDARY: $(obj)/$(builtindtb-y).dtb.S
>> Note, this may not work if you're using CONFIG_ARC_BUILTIN_DTB_NAME,
>> since it'll have quotes around it, so you may instead need:
>> .SECONDARY: $(obj)/$(patsubst "%",%,$(builtindtb-y)).dtb.S
>>
>> (at least that's what's required for the metag equivalent)
>>
>>> +
>>>  dtbs:  $(addprefix  $(obj)/, $(builtindtb-y).dtb)
>> You might find the same thing here too.
> 
> Actually in my Makefile, the quotes are stripped off in the very beginning to
> avoid duplicating it in every place.
> 
> ifneq ($(CONFIG_ARC_BUILTIN_DTB_NAME),"")
>     builtindtb-y    := $(patsubst "%",%,$(CONFIG_ARC_BUILTIN_DTB_NAME))
> endif

Ah yes, I didn't notice that difference. I'll do the same thing for
metag (it only had 1 reference to it before).

Thanks
James

