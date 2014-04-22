Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaDVInq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:43:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44887 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaDVInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:43:42 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-f0-53562bbb8802
Message-id: <53562BA4.6020902@samsung.com>
Date: Tue, 22 Apr 2014 10:43:16 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for	components
 tracking
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
 <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
 <20140417214709.GY24070@n2100.arm.linux.org.uk> <53510C39.1020205@samsung.com>
 <20140418124202.GD24070@n2100.arm.linux.org.uk>
In-reply-to: <20140418124202.GD24070@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7q7tcOCDZac4LLoPXeSyeLvpGPs
	Fle+vmezaF68ns1i0v0JLBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYu2Ru+wW62e8ZnHg
	8Whp7mHz+P1rEqPH9m8PWD32z13D7nG/+ziTx+Yl9R59W1YxenzeJBfAEcVlk5Kak1mWWqRv
	l8CVsXW1dcEZ8YrmB9+YGxhvC3UxcnBICJhI9J0S62LkBDLFJC7cW8/WxcjFISSwlFHixvST
	TBDOJ0aJZXdvM4M08ApoSaz47QzSwCKgKtF+aQ0riM0moCnxd/NNNhBbVCBC4l7jYbA4r4Cg
	xI/J91hAbBEBU4lrj54xg8xkFmhikZhzdQZYQlggUmLl3lUsEMsamCROTZnPDJLgFLCRmLiy
	mRHEZhbQkdjfOo0NwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWl
	eel6yfm5mxghEfN1B+PSY1aHGAU4GJV4eCUMQoOFWBPLiitzDzFKcDArifA2aYYFC/GmJFZW
	pRblxxeV5qQWH2Jk4uCUamC8FiwWubxVKuJwv3hmWZPtxRLzG8JLD6ZMXni379nLk5GxH+xr
	l7zZF8x0bmVpRlfY67jz+XGcGU46yRKsGecr34mtFXE0Uqo08dfwOuMRP+8t34L7+2O/rjRr
	fBxiuMnSP45xMl/BMQVdDq6EN+GJxVuuixf2flAQ0euf0SKkelHIcat7jBJLcUaioRZzUXEi
	AH1llWp2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

My answer little bit later due to Easter.

On 04/18/2014 02:42 PM, Russell King - ARM Linux wrote:
> On Fri, Apr 18, 2014 at 01:27:53PM +0200, Andrzej Hajda wrote:
>> Hi Russel,
>>
>> Thanks for comments.
>>
>> On 04/17/2014 11:47 PM, Russell King - ARM Linux wrote:
>>> On Thu, Apr 17, 2014 at 01:28:50PM +0200, Andrzej Hajda wrote:
>>>> +out:
>>>> +	if (ret != -EPROBE_DEFER)
>>>> +		exynos_drm_dev_ready(&pdev->dev);
>>> So we end up with everyone needing a "ready" call in each sub-driver
>>> back into the main driver... this makes it impossible to write a
>>> generic subcomponent driver which is not tied in any way to the
>>> main driver.
>>>
>>> That is quite some restriction, and would prevent, for example, the
>>> TDA998x driver being used both with Armada DRM, tilcdc and any other
>>> driver.
>> As I see in armada driver drm is deferred in case tda998x is not yet
>> available. The same solution can be still used with pending_devices
>> approach - the main driver will not report its readiness until tda998x
>> is present.
>>
>> Anyway it still seems to be better than componentize every driver which can
>> probably become a part of some superdevice.
>>
>> If you want to get rid of deferred probe one can make global list of
>> 'ready' devices with notifications systems for master devices.
>>
>> Maybe it would be good to consider notification system for devices probe
>> result,
>> it will require that driver register all its interfaces in probe, ie its
>> readiness cannot
>> be reported later but will not require to add new framework. I hope just
>> extending current
>> notification system should be enough.
> You aren't addressing my point.  If I were to convert tda998x to use
> your infrastructure, then I would have to add in ifdefs to tie it into
> armada DRM _and_ a different set of ifdefs to tie it into tilcdc.  Then
> when someone else wanted to use it in their driver, they'd have to add
> yet more ifdefs into it to tie it into their driver.
>
> This does not scale.

As I already answered, you should not use 'my' framework for tda998x
driver, you can still use current approach with deferred probe. I am not
sure
why have you used ifdefs in armada, tilcdc also uses tda998x and without
ifdefs.

'My' framework (I think helper library is a better name) was created to
use with
devices which are closely tied together by another framework - case
of some SoC devices.


>
> So, please address my point: in your system, how can a single component
> be shared between multiple different master drivers?
>

I have answered this question above, again. But your question suggests
you want to componentize
also drivers which are shared by different DRMs. How do you want to do it?
- componentize all DRM drivers sharing given driver?
- componentize shared device in a way that it can used by
non-componentized devices? how? I guess it
will be possible but will have some price.

Regards
Andrzej



