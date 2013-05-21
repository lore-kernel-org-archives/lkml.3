Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3EUMPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:15:37 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:51916 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750766Ab3EUMPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:15:35 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 08:15:35 EDT
Message-ID: <519B63D3.7040600@epfl.ch>
Date: Tue, 21 May 2013 14:08:51 +0200
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@iki.fi>, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] ARM: OMAP4: change the device names in usb_bind_phy
References: <1366697656-14315-1-git-send-email-kishon@ti.com> <51936946.3030507@iki.fi> <20130516155857.GV5600@atomide.com> <519503DA.5070303@iki.fi> <20130516162034.GX5600@atomide.com> <5195C28C.40300@ti.com> <20130517172335.GX5600@atomide.com>
In-Reply-To: <20130517172335.GX5600@atomide.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/17/2013 07:23 PM, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [130516 22:45]:
>> Hi,
>>
>> On Thursday 16 May 2013 09:50 PM, Tony Lindgren wrote:
>>> * Tomi Valkeinen <tomi.valkeinen@iki.fi> [130516 09:11]:
>>>> On 16/05/13 18:58, Tony Lindgren wrote:
>>>>> * Tomi Valkeinen <tomi.valkeinen@iki.fi> [130515 03:59]:
>>>>>
>>>>> Just checking.. Do you have CONFIG_OMAP_OCP2SCP=y in your .config? Sounds
>>>>> like the some transceivers should depend on that for omap4.
>>>>
>>>> Yes, I have OCP2SCP=y.
>>>
>>> Hmm well no idea beyond that then. Sounds like Kishon should check it.
>>>
>>>>>> The musb-hdrc id is wrong on overo also.
>>>>>
>>>>> Hmm has there been a fix posted for that?
>>>>
>>>> I couldn't find with a quick look. We debugged and discussed this on an irc
>>>> channel with Kishon, who said he'll send a patch. Changing the musb-hdrc ID
>>>> on overo fixed the issue, and it looks very similar to the error on 4430sdp.
>>>> The overo fix was just:
>>
>> hmm.. I think using device name to bind the controller and the phy
>> can no longer be used reliably. I think it's better to have
>> something like what Grant suggested in my other patch series.. to
>> have the phy reference into the host controllers platform_data
>> structure. And for the phy reference I'll have label and id.
>>
>> Does this makes sense to you?
>
> Sounds OK to me, but I guess that would be for v3.11. I think we
> still need a fix for at least overo for v3.10?
>

Indead, musb-hdrc is broken on overo with 3.10-rc2. The patch posted in this
thread fixes the issue.

Regards,

Florian
