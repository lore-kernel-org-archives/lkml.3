Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaENO6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:58:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49499 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbaENO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:58:48 -0400
Message-ID: <53738496.2070800@ahsoftware.de>
Date: Wed, 14 May 2014 16:58:30 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 5/9] dt: deps: register drivers based on the initialization
 order based on DT
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-6-git-send-email-holler@ahsoftware.de> <20140514141300.67206C4153D@trevor.secretlab.ca>
In-Reply-To: <20140514141300.67206C4153D@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 16:13, schrieb Grant Likely:
> On Mon, 12 May 2014 18:47:56 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
>> The init system currently calls unknown functions with almost unknown
>> functionality in an almost random order.
>
> Correct, we've got a module system. Some would say that is a strength!
> :-) That said, I don't object to optimizing to the optimal order when
> possible.

Modules do work after init happened, that isn't what this feature is about.

>
>> Fixing this is on a short-term basis is a bit tricky.
>>
>> In order to register drivers with a deterministic order, a list of all
>> available in-kernel drivers is needed. Unfortunately such a list doesn't
>> exist, just a list of initcalls does exist.
>>
>> The trick now is to first call special annotated initcalls (I call those
>> "well done") for platform drivers, but not actualy starting those drivers
>> by calling their probe function, but just collectiong their meta datas
>> (struct platform_driver). After all those informations were collected,
>> available the drivers will be started according to the previously
>> determined order.
>
> Why does the initcall level matter? Why not just let the initcalls
> happen, capture the calls that register a driver, and then use that list
> later?

Some initcalls assume that stuff is present when they called probe or 
register and do further action based on the rc code.

>> The long range target to fix the problem should be to include a list (array)
>> of struct platform_driver in the kernel for all in-kernel platform drivers,
>> instead of just initcalls. This will be easy if all platform drivers have
>> become "well done".
>
> How will that list be constructed? How will it account for multiple
> platforms, each requiring a different init order?

The list could be build just like the list of initcalls, but containing 
structs platform instead of function pointers.

The order is in now way part of this list, after all that's what this 
feature is about. The order is determined by metadatas in the DT, to get 
rid of a lot of otherwise necessary hardcoded stuff to fix the order in 
drivers.

Regards,

Alexander Holler
