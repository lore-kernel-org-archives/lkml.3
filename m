Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaENS4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:56:37 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48610 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaENS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:56:35 -0400
Message-ID: <5373BC5D.7010300@gmail.com>
Date: Wed, 14 May 2014 20:56:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <5764751.ffUj9rhnMd@wuerfel> <5373B908.5090904@gmail.com> <17808571.N5ZGjXFEVP@wuerfel>
In-Reply-To: <17808571.N5ZGjXFEVP@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 08:51 PM, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 20:42:16 Sebastian Hesselbarth wrote:
>>>> For the driver, Antoine then would have to squeeze all PHY register
>>>> mangling in phy-berlin2.c and see how to make ahci-platform aware of
>>>> individual port nodes (I haven't looked up if it already exists, sorry)
>>>> and announce only enabled port child nodes, right?
>>>
>>> I've been thinking some more about this aspect. I don't actually have
>>> a strong opinion on whether it's better to use the generic ahci-platform
>>> driver, or to keep the multi-phy support as a special variant for
>>> berlin. If we do the latter, it would however be good to define the
>>> binding in a way that lets us later merge things into the generic phy
>>> driver in case we get more of the same.
>>
>> Hmm, IMHO multi-phy support is orthogonal to ahci-platform, isn't it?
>> ahci-platform needs to know about the phy property and calls some
>> helper that deals with the phy-specifier?
>>
>> About a generic _phy_ driver, I am not so sure if berlin is the best
>> template right now 
>>
>> So, my call would be:
>> - make ahci-platform aware of port sub-nodes and phy properties
>> - have a berlin specific PHY driver
> 
> I'm not sure if we need sub-nodes per port, it should be enough
> to have an array of phys, plus a way to match them up with the
> ports.

Actually, I'd love to see sub-nodes per port as it will allow to
disabled unused ports on a per-board basis.

I have this in mind for a long time for Kirkwood's SATA node already:
Consider a board where you have the one available SATA plug connected
to port 1. How would that work out with status = "disabled"/"okay" that
doesn't allow array of strings obviously?

Sebastian

