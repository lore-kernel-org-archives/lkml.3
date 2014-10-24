Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaJXM2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:28:46 -0400
Received: from down.free-electrons.com ([37.187.137.238]:39325 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756140AbaJXM2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:28:45 -0400
Message-ID: <544A45F7.5070300@free-electrons.com>
Date: Fri, 24 Oct 2014 14:28:39 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 2/4] ARM: mvebu: Move SCU power up in a function
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com> <1414088070-12510-3-git-send-email-gregory.clement@free-electrons.com> <20141024140551.0890f204@free-electrons.com> <544A41E5.2090802@free-electrons.com> <20141024141958.319af5d3@free-electrons.com>
In-Reply-To: <20141024141958.319af5d3@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 24/10/2014 14:19, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Fri, 24 Oct 2014 14:11:17 +0200, Gregory CLEMENT wrote:
> 
>>> Since this function is not static, I think it might be a good idea to
>>> use a prefix that makes it more specific to the platform in order to
>>> not pollute the global namespace. Maybe something like
>>> 'armada_38x_scu_power_up', or something like that.
>>
>> Yes given the fact that this function is declared in the mach-mveu folder
>> it is sensible to use a more specific name. However the function itself
>> is not specific at all to an SoC. This function could be used for any Cortex A9
>> using the SCU.
> 
> Indeed, but as you say, it's right now defined in the mvebu specific
> code, so we shouldn't pollute the global namespace.
> 
> Note that there is already a scu_power_mode() that does the same thing,

I know this function: I used it for the idle support.

> but implemented in C, so I'm not sure you can call it at search an early
> point.

you meant "such" instead of "search" I guess, and yes unfortunately we can't use
a C function at this step.

Gregory



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
