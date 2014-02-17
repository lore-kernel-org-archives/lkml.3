Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaBQOda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:33:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39430 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbaBQOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:33:28 -0500
Message-ID: <53021D4A.6080901@free-electrons.com>
Date: Mon, 17 Feb 2014 15:31:38 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] clk: respect the clock dependencies in of_clk_init
References: <1392054179-28830-1-git-send-email-gregory.clement@free-electrons.com> <20140211173203.4e6c7b22@skate>
In-Reply-To: <20140211173203.4e6c7b22@skate>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I would like to know if you consider to take the following patch.
If you don't then I will have to amend the patch set adding support
to Armada 375/38x SoC with the same kind of solution that Sebastian
used for the other mvebu clocks.

Thanks,

Gregory


On 11/02/2014 17:32, Thomas Petazzoni wrote:
> Hello,
> 
> On Mon, 10 Feb 2014 18:42:59 +0100, Gregory CLEMENT wrote:
>> Until now the clock providers were initialized in the order found in
>> the device tree. This led to have the dependencies between the clocks
>> not respected: children clocks could be initialized before their
>> parent clocks.
>>
>> Instead of forcing each platform to manage its own initialization order,
>> this patch adds this work inside the framework itself.
>>
>> Using the data of the device tree the of_clk_init function now delayed
>> the initialization of a clock provider if its parent provider was not
>> ready yet.
>>
>> The strict dependency check (all parents of a given clk must be
>> initialized) was added by Boris BREZILLON
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>
>> Since the v1, I have merged the  strict dependency check from Boris.
>> And of course tested on my Armada 370 and Armada XP based board
>>
>>  drivers/clk/clk.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 106 insertions(+), 3 deletions(-)
> 
> Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> On the newly proposed Armada 375 platform.
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
