Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3DWJUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:20:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3DWJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:20:11 -0400
Message-ID: <5176520B.2040004@ti.com>
Date: Tue, 23 Apr 2013 12:19:07 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: Kevin Hilman <khilman@linaro.org>, <gregkh@linuxfoundation.org>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [RFC/PATCHv2 5/5] arm: omap2+: omap_device: remove no_idle_on_suspend
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>	<1366638237-6880-6-git-send-email-sourav.poddar@ti.com>	<517545C2.3080006@ti.com> <87y5ca76hm.fsf@linaro.org> <517619DF.5010803@ti.com>
In-Reply-To: <517619DF.5010803@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.172]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:19 AM, Sourav Poddar wrote:
> Hi Kevin,
> On Tuesday 23 April 2013 12:11 AM, Kevin Hilman wrote:
>> Grygorii Strashko<grygorii.strashko@ti.com>  writes:
>>
>>> On 04/22/2013 04:43 PM, Sourav Poddar wrote:
>>>> Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since
>>>> driver should be able to prevent idling of an omap device
>>>> whenever required.
>>>>
>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>> Cc: Grygorii Strashko<grygorii.strashko@ti.com>
>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>>> ---
>>>> Hi Kevin,
>>>>
>>>> I have put this as an RFC, due to few comments on cover letter of
>>>> the previous version by Grygorii Strashko.
>>>> As, he has mentioned that there are Audio playback use cases which
>>>> also requires "no_idle_on_suspend" and using them on mainline after
>>>> this series can cause regression.
>>>>
>>>> What you think will be the right approach on this in relation to 
>>>> this patch?
>>>> I mean every driver(if possible) should  prevent
>>>> runtime PM for no_idle_on_suspend usecase and we get
>>>> rid of this OMAP_DEVICE_NO_IDLE_ON_SUSPEND check? OR we should
>>>> drop this patch as of now?
>> This is the correct approach, and AFAICT you've fixed the *mainline*
>> users of this patch which is the important part.  If there are other
>> mainline users of this feature, we need to know about them.
>>
>> Let me be clear: this OMAP_DEVICE_NO_IDLE_ON_SUSPEND feature is a hack
>> (it was introduced by me, but still a hack.)  We've found a way to
>> handle using the generic framework, and we should move to that. There
>> are already a handful of complications when combining runtime PM and
>> system suspend, and this is just another one.  It makes the most sense
>> for this handling to be in the drivers themselves.  IOW: if the driver
>> wants to refuse to runtime suspend (during system suspend), it has the
>> choice.
>>
> Yes, I was also of the same view that the driver should take care of the
> no_idle_on_suspend case and we should get rid of the hacks around this.
> Modifying a respective driver will be a more generic solution which 
> will work
> irrespective of dt and non dt boot.
Hi Sourav, Kevin,

Let it be, but could you update patch description with detailed explanation
of what drivers should do from now to be able to use such functionality
(make IP active while System is suspended).
So, people, who've used this hack before (even if these users are not in 
*mainline*)
will know what to do.

Regards
-grygorii

>>>> Hi Grygorii,
>>>>
>>>> Is it possible to handle ABE no_idle_on_suspend uscase the way I am
>>>> trying to handle it for UART in the 2nd patch of this series?
>>> Unfortunately, I don't know ASOC details (my part is PM),  but from
>>> the first look it
>>> will be not easy, because map4-dmic have no Runtime PM handlers at
>>> all, for example ((
>> Are those drivers upstream?  If so, please point them out and show how
>> this feature is being used in *mainline* by those drivers.
>>
>> For OMAP PM, we have been very clear for a long time all of our PM was
>> based on runtime PM.  Any drivers that are not runtime PM are broken and
>> need to be fixed.
>>
>> As long as Sourav is fixing up all the mainline users of this 
>> feature, my
>> plan to merge/ack the changes unless there are some good arguemnts based
>> on *upstream* users of the feature.
>>
>> Kevin
>>
>

