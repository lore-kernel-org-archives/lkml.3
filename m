Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBKRbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:31:44 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38451 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084AbaBKRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:31:42 -0500
Message-ID: <52FA5E75.7030402@free-electrons.com>
Date: Tue, 11 Feb 2014 18:31:33 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Josh Cartwright <joshc@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of of_find_matching_node_and_match
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>	<1392135847-30791-5-git-send-email-joshc@codeaurora.org>	<20140211165314.GA8533@titan.lakedaemon.net> <20140211181048.6934bdd3@skate>
In-Reply-To: <20140211181048.6934bdd3@skate>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2014 18:10, Thomas Petazzoni wrote:
> Dear Jason Cooper,
> 
> On Tue, 11 Feb 2014 11:53:14 -0500, Jason Cooper wrote:
> 
>>> -	np = of_find_matching_node(NULL, of_system_controller_table);
>>> +	np = of_find_matching_node_and_match(NULL, of_system_controller_table,
>>> +					     &match);
>>>  	if (np) {
>>> -		const struct of_device_id *match =
>>> -		    of_match_node(of_system_controller_table, np);
>>
>>
>>> -		BUG_ON(!match);
>>
>> Gregory, is it ok to remove this?  It was added with the original code
>> submission for mach-mvebu.  mvebu_restart() will handle this
>> gracefully...
> 
> The BUG_ON here can normally never be reached. If
> of_find_matching_node() returns a non-NULL result, then of_match_node()
> should also return a non-NULL result.
> 
> Or I'm missing something :)

No you're almost right!

The only case we can get it, would be if we were declaring something like:

static struct of_device_id of_system_controller_table[] = {
	{
		.compatible = "foo,bar-controller",
	},
[...]

instead of

static struct of_device_id of_system_controller_table[] = {
	{
		.compatible = "foo,bar",
		.data = (void *) &bar_controller,
	},
[...]

This test is very paranoid, so I agree to remove it.


Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory


> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
