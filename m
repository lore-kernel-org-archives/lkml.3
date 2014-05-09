Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaEIJxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:53:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54795 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaEIJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:53:28 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-11-536ca595f9e7
Message-id: <536CA593.3070907@samsung.com>
Date: Fri, 09 May 2014 11:53:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: robh+dt@kernel.org, grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: Add of_device_destroy_children() function
References: <1399567069-3174-1-git-send-email-s.nawrocki@samsung.com>
 <20140508203339.GA542@obsidianresearch.com>
In-reply-to: <20140508203339.GA542@obsidianresearch.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xa7pTl+YEGyy5pGYx/8g5VosDf3Yw
	Wny/YWqx6fE1VovLu+awWbTuPcLuwOaxaVUnm8eda3vYPDYvqff4vqOX0ePzJrkA1igum5TU
	nMyy1CJ9uwSujHvTL7AUzOeuuPJ3JWMDYzNnFyMHh4SAicTxiaxdjJxAppjEhXvr2boYuTiE
	BJYySlyc8QnK+cQoMX3aA2aQKl4BLYlZa5cygdgsAqoSv66vYQSx2QQMJXqP9jGCDBUViJB4
	fEEIolxQ4sfkeywgtoiAqcTx43eYQGYyC0xklDg5+xxYQljASWLOhUnsILaQQLHE6p+bmUDm
	cApYSFycLg8SZhbQkdjfOo0NwpaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqaXJBcVJ6bmG
	esWJucWleel6yfm5mxghQf1lB+PiY1aHGAU4GJV4eF9EZwQLsSaWFVfmHmKU4GBWEuF9Nj0n
	WIg3JbGyKrUoP76oNCe1+BAjEwenVANjv+WKQFnpGaHnrIp2zYt7LZxd/j/eouKd3J4WvV2X
	b5/vWP5o66PKiXnHd2S6pWmmHw7Va+UJXbsykp3RZpv8DEauR9KhNy82iNrLTmNf+vTy8XlG
	FZOim6wWmfhIS27w3XNR5wnTAy3GyI3GEydOXnrxq2SjPJ8xa3vRHdkSlsm717PP3MGuxFKc
	kWioxVxUnAgAVO9EVkgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/14 22:33, Jason Gunthorpe wrote:
> On Thu, May 08, 2014 at 06:37:49PM +0200, Sylwester Nawrocki wrote:
>> This patch adds a helper function to unregister devices which
>> were created by an of_platform_populate() call. The pattern
>> used here can already be found in multiple drivers. This helper
>> can now be used instead of repeating similar code in drivers.
> 
> I have a driver that does this as well, and what I found is that the
> remove must be in reverse order from the create or things explode, and
> that assumes the DT is topologically sorted according to dependency
> (so no deferred probe).
> 
> AFAIK, there is no analog to deferred probe for removal, and
> attempting to remove, say, a GPIO driver while an I2C bit bang is using
> it just fails.

Thanks for the feedback, I knew I could be missing some of nasty
details like this. Looks like we need a complete implementation
of of_platform_unpopulate(). Since the are cases where the remove
order is insignificant, I'm wondering whether it still would be
useful to have a helper like device_unregister_children() which
would remove only direct children of a device ? At least this
solves my current problem.

Since the dependencies will likely never be fully described in DT
I guess we would need to create a list while actually creating
devices, to be able to walk in reverse order while destroying them.

--
Regards,
Sylwester

