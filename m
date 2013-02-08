Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946563Ab3BHNHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:07:54 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44873 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946394Ab3BHNHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:07:53 -0500
Message-ID: <5114F8A6.60105@gmail.com>
Date: Fri, 08 Feb 2013 07:07:50 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 0/4] Improve CLKSRC_OF matching
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <1360299102.31290.1.camel@gitbox>
In-Reply-To: <1360299102.31290.1.camel@gitbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 10:51 PM, Tony Prisk wrote:
> On Thu, 2013-02-07 at 13:09 -0600, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> In the recently added support for OF based clocksource init, a device node
>> will be matched twice. We can fix this by passing the device node to the
>> init functions and removing the match functions within the init functions.
>>
>> This is based on arm-soc for-next branch and commit "of: fix incorrect
>> return value of of_find_matching_node_and_match()" in my DT for-next
>> branch.
>>
>> Rob
>>
>> Rob Herring (4):
>>   clocksource: pass DT node pointer to init functions
>>   clocksource: bcm2835: use the device_node pointer passed to init
>>   clocksource: vt8500: use the device_node pointer passed to init
>>   clocksource: tegra20: use the device_node pointer passed to init
>>
>>  drivers/clocksource/bcm2835_timer.c |   12 +-----
>>  drivers/clocksource/clksrc-of.c     |    4 +-
>>  drivers/clocksource/tegra20_timer.c |   70 ++++++++++++++---------------------
>>  drivers/clocksource/vt8500_timer.c  |   14 +------
>>  4 files changed, 31 insertions(+), 69 deletions(-)
>>
> 
> Looks fine, although I didn't get a CC for the vt8500 patch so I had to
> go hunting for it :)

Since it got moved to drivers/clocksource, did MAINTAINERS get updated?
I just ran get_maintainers.pl.

Stephen also needs to add himself to Tegra as I had to add him manually.

Rob

> 
> For patches 1 & 3:
> Acked-by: Tony Prisk <linux@prisktech.co.nz>
> 

