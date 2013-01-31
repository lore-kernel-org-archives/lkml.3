Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3AaIKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:10:04 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37453 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab3AaIKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130131072808.GA2041@avionic-0098.mockup.avionic-design.de>
References: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
	<20130131072808.GA2041@avionic-0098.mockup.avionic-design.de>
Date: Thu, 31 Jan 2013 13:39:59 +0530
Message-ID: <CAK9yfHy3qV1b5c586ToHONBu3BQdkdM4hYbvJcofZ=kL70rZjA@mail.gmail.com>
Subject: Re: [PATCH 1/1] dma: pl330: Convert to devm_ioremap_resource()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 12:58, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Thu, Jan 31, 2013 at 12:37:04PM +0530, Sachin Kamat wrote:
>> Use the newly introduced devm_ioremap_resource() instead of
>> devm_request_and_ioremap() which provides more consistent error handling.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Thierry Reding <thierry.reding@avionic-design.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>> This change is based against linux-next tree (20130128).
>> This change however introduces the followign sparse warning:
>> drivers/dma/pl330.c:2883:22: warning: incorrect type in argument 1 (different address spaces)
>> drivers/dma/pl330.c:2883:22:    expected void const *ptr
>> drivers/dma/pl330.c:2883:22:    got void [noderef] <asn:2>*base
>> drivers/dma/pl330.c:2884:34: warning: incorrect type in argument 1 (different address spaces)
>> drivers/dma/pl330.c:2884:34:    expected void const *ptr
>> drivers/dma/pl330.c:2884:34:    got void [noderef] <asn:2>*base
>
> Yes, those are false positives. They can be fixed with the two patches I
> posted a few hours ago, starting here:
>
>         https://lkml.org/lkml/2013/1/30/455

OK. That's great.
>
> Note that the first patch is against sparse. The problem, in a nutshell,
> is that sparse complains that the pointer address spaces and noderef
> attributes differ. In the case of the IS_ERR() function and friends the
> attributes aren't relevant because only the pointer value is only used
> arithmetically. Unfortunately there is no way you can cast away these
> attributes without causing other warnings, so the solution is somewhat
> more complex.

Thanks for the explaination.
However, is the patch for the dma relevant?


-- 
With warm regards,
Sachin
