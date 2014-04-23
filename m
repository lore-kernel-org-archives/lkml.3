Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaDWOtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:49:43 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56249 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbaDWOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJSSHMaR=NJ3XWscxz1dKtG1N18W6JNDNKY3r3vtf9AXQ@mail.gmail.com>
References: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
 <CAL_JsqJFM1e2Y7GykK06KuZ8fD8iZ=64W1i+tqibJ9datCUR0Q@mail.gmail.com>
 <20140423140508.2575AC408D2@trevor.secretlab.ca> <CAL_JsqJSSHMaR=NJ3XWscxz1dKtG1N18W6JNDNKY3r3vtf9AXQ@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 23 Apr 2014 15:49:17 +0100
X-Google-Sender-Auth: tWoMW5M1qfbMVNrnQDXyyWZkj3Y
Message-ID: <CACxGe6vA2+BwJkA_N0m=c9GcdRUQotdjjDg=Vh10EJOcNxpPTQ@mail.gmail.com>
Subject: Re: [RFC] driver-core: Remove dummy 'platform_bus'
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 3:16 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Apr 23, 2014 at 9:05 AM, Grant Likely <grant.likely@linaro.org> wrote:
>> On Mon, 21 Apr 2014 16:05:29 -0500, Rob Herring <robherring2@gmail.com> wrote:
>>> On Wed, Nov 21, 2012 at 8:44 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> > The "platform_bus" (note: not platform_bus_type) only exists as an empty
>>> > directory to put platform devices into. However, it really doesn't make
>>> > sense to segregate all the platform devices into a sub directory when
>>> > typically they are memory mapped devices that doen't go through any
>>> > particular bus. Particularly on embedded type platforms the platform_bus
>>> > directory doesn't add anything.
>>> >
>>> > However, this will probably just end up breaking some userspace that
>>> > depends on the /sys/devices/platform/ path to be present (no matter how
>>> > much we protest that userspace must not depend on paths in sysfs). So
>>> > while I'm seriously proposing this change, it may just be unacceptable
>>> > ABI breakage
>>>
>>> An old thread, but was there ever a conclusion to this? We now have a
>>> mixture of using platform_bus as the parent or not on various ARM
>>> platforms.
>>
>> We kind of concluded in the opposite direction. Instead of removing the
>> /sys/device/platform directory, the drivers/of code should be changed to
>> use it.
>>
>> The following patch is sufficient to have the same effect. It doesn't
>> unify the OF and non-OF paths of platform device addition, but it gets
>> them closer. I've been nervous about applying it because I'm concerned
>> about userspace breakage, but maybe it just needs to be merged and we
>> can quirk out systems that break.
>
> Given that we've changed practically all device names in converting to
> DT and I haven't heard of any complaints, we may be okay.
>
> We also have some platforms (imx6 for example) setting the parent to
> an soc device. I still need to understand why the soc device needs to
> be the parent, but it is pointless platform variation in my book. It
> would also change the paths when someone has the whim to add an soc
> device.

Yes, that is just dumb and should be discouraged.

g.
