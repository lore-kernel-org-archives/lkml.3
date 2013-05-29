Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab3E2NgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:36:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55118 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759457Ab3E2NgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:36:16 -0400
Message-ID: <51A60427.6010409@ti.com>
Date: Wed, 29 May 2013 15:35:35 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Jon Hunter <jgchunter@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
References: <cover.1369658705.git.afzal@ti.com> <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com> <51A520B5.8040803@gmail.com> <51A52A16.1040204@wwwdotorg.org> <C8443D0743D26F4388EA172BF4E2A7A93EAFB044@DBDE04.ent.ti.com> <51A5BEB6.6070809@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EAFB174@DBDE04.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EAFB174@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 11:58 AM, Mohammed, Afzal wrote:
> Hi Benoit,
> 
> On Wed, May 29, 2013 at 14:09:18, Cousson, Benoit wrote:
>> On 05/29/2013 10:06 AM, Mohammed, Afzal wrote:
>>> On Wed, May 29, 2013 at 03:35:10, Stephen Warren wrote:
>>>> On 05/28/2013 03:25 PM, Jon Hunter wrote:
> 
>>>>> If you are adding more compatibility strings, then this implies that the
>>>>> AM43x timers are not 100% compatible with any other device listed (such
>>>>> as am335x or any omap device). That's fine but you should state that in
>>>>> the changelog. If the AM43x timer registers are 100% compatible with
>>>>> existing devices you should not add these.
>>>>
>>>> I'm not sure that's true; .dts files should always include a compatible
>>>> value that describes the most specific model of the HW, plus any
>>>> baseline compatible value that the HW is compatible with. This allows
>>>> any required quirks/fixes/... to be applied for the specific HW model
>>>> later even if nobody knows right now they'll be needed. Hence, defining
>>>> new compatible values doesn't necessarily mean incompatible HW.
>>>
>>> Stephen took words out of my finger ;)
>>>  
>>> Some explanations,I don;t 
>>>
>>> 1. first compatible should be exact device [A], followed by compatible
>>> model (if one)
>>> 2. Minor effort in getting DT right the first time may help prevent
>>> difficult effort later modifying it (if a necessity comes), considering
>>> the fact that DT sources has  to move out of Kernel at some point of
>>> time. And DT is not supposed to be modified, which may cause difficulty
>>> for the users (I had been a minor victim of this during rebase).
>>>
>>> As we both were in GPMC land earlier, an example,
>>>
>>> If my memory is right, GPMC IP in am335x is rev 6, and IP has 8 chip
>>> select, but one is not pinned out. Now assume that same IP is integrated
>>> in another SoC (probably OMAP4 has rev 6). Here if we use same compatible
>>> for both, driver cannot handle it properly (w/o knowledge about platform).
>>> But if exact compatible is mentioned, without modifying DT (which should
>>> be considered as a firmware) just by modifying Kernel, deciding based on
>>> compatible would help achieve what is required.
>>
>> That's true for the DTS itself, but here your are changing the binding
>> documentation which is supposed to reflect the driver "interface" in the
>> Device Tree model description.
>>
>> Since the driver does not support any new compatible string, you should
>> not update the binding.
> 
> I have a different opinion: Binding documentation is to be considered an
> entity that is not a part of the Kernel, but currently is a part of the
> Kernel for want of a better place. And binding is to be considered OS
> agnostic being ignorant of any piece of software (driver here).

OK, that part is correct, but instead of driver I should have said HW
device. The binding is supposed to identify a specific HW device
revision or family if some HW registers are there to identify the version.

> Binding has the authority to allow its usage in DT sources.

And in this case, you do not introduce any new revision.

There is no point to update the binding each time we add a new SoC
variant that will contain the exact same IP.

I think it will mainly confuse the user that will wonder what is
different in that version compare to the previous one, moreover we can
end up with hundred of entries for the exact same IP for nothing.

The real problem is due to the introduction of the SoC name in the
device compatible name. That does introduced a SoC level information
that is mostly irrelevant at device level. I can understand why it was
done for practical aspect when the IP version is not well identified,
but that can lead to this proliferation of new pointless bindings.

>> The driver and the binding will have to be changed the day you will have
>> to update the driver to handle a bug / feature specific to that revision
>> (ti,am4372-timer).
>>
>> Since this series does not seems to update the driver, you should not
>> update the bindings.
> 
> I believe that updating binding is a prerequisite for making a new
> DTS change, hence binding was updated first, then DTS.

I don't think so, as soon as you still use at least one documented
compatible binding in the DTS description.

It is not anyway really armless, it just adds much more confusion that
real useful information for my point of view.

Regards,
Benoit

