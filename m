Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945954Ab3BGXgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:36:44 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47126 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500Ab3BGXgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:36:43 -0500
Message-ID: <51143A87.4040205@gmail.com>
Date: Thu, 07 Feb 2013 17:36:39 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 0/4] Improve CLKSRC_OF matching
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <201302072244.51588.arnd@arndb.de>
In-Reply-To: <201302072244.51588.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 04:44 PM, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Rob Herring wrote:
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
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Conceptually this is definitely the way to go, but I noticed that
> you create build warnings for the bisection points after the
> first patch. I would suggest actually merging the first three
> patches into one and also changing the prototype for the tegra
> function in that patch to avoid this.
> 

How so? I don't see a warning as there is no type checking on the init
function since of_device_id.data is just a void *. It would be good to
have type checking here if you know a way, but I don't. I agree it is a
bit abusive and can change it as you suggest.

Rob
