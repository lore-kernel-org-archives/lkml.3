Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaENRUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:20:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39445 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaENRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:20:48 -0400
Message-ID: <5373A5D5.5080709@ahsoftware.de>
Date: Wed, 14 May 2014 19:20:21 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-3-git-send-email-holler@ahsoftware.de> <20140514140534.897F8C4153D@trevor.secretlab.ca> <53738261.4000000@ahsoftware.de>
In-Reply-To: <53738261.4000000@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 16:49, schrieb Alexander Holler:
> Am 14.05.2014 16:05, schrieb Grant Likely:
>> On Mon, 12 May 2014 18:47:53 +0200, Alexander Holler
>> <holler@ahsoftware.de> wrote:

>> Personally, I think the parts of this patch that manipulate the device
>> registration
>> order is entirely the wrong way to handle it. If anything, I would say
>> continue to register the devices, even if the dependencies are unmet.

(...)

>> How does the dependency code decide which devices can be
>> platform_devices? It's not clear to me from what I've read so far.
>
> Dependencies currently are only considered on stuff which has a
> "compatibility" property, thus drivers. I wanted to get the drivers
> loaded in order, not really caring for devices. Let me quote from
> (outdated) ldd3:
>
> "For the most part, the Linux device model code takes care of all these
> considerations without imposing itself upon driver authors. It sits
> mostly in the background; direct interaction with the device model is
> generally handled by bus-level logic and various other kernel
> subsystems. As a result, many driver authors can ignore the device model
> entirely, and trust it to take care of itself."
>
> So do I. ;)

To explain a bit further, I've started with totally ignoring the device 
model just careing for the order in why drivers will be initialized.

Than the device model did come into my way. ;)

But it isn't any problem at all to extend the stuff to care for devices. 
That even  would reduce some code in dtc with the disadvantage that the 
sizes of blobs will slightly increase a bit more, because they then 
would include dependencies to devices too (instead of just dependencies 
between drivers).

So I'm absolutely open here. If using dependencies between devices is 
necessary or has advantages, that could be changed with changing a few 
lines.

Regards,

Alexander Holler
