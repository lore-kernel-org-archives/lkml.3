Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3KEWRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:17:44 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59236 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3KEWRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:17:43 -0500
Message-ID: <52796E82.5010800@gmail.com>
Date: Tue, 05 Nov 2013 23:17:38 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: Arnaud Ebalard <arno@natisbad.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] net: mv643xx_eth: Add missing phy_addr_set in DT mode
References: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com> <87sivacxcf.fsf@natisbad.org>
In-Reply-To: <87sivacxcf.fsf@natisbad.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 11:12 PM, Arnaud Ebalard wrote:
> Hi Jason,
>
> Jason Gunthorpe <jgunthorpe@obsidianresearch.com> writes:
>
>> Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node
>> present' made the call to phy_scan optional, if the DT has a link to
>> the phy node.
>>
>> However phy_scan has the side effect of calling phy_addr_set, which
>> writes the phy MDIO address to the ethernet controller. If phy_addr_set
>> is not called, and the bootloader has not set the correct address then
>> the driver will fail to function.
>
> Thanks *a lot* for fixing this one! I had the issue on my ReadyNAS 102
> (Armada 370 based) which I had put on a todo list and temporarily

Erm, just to make sure: Armada 370 isn't using mv643xx_eth but mvneta,
are you sure it is (was) related to Jason's fix?

Sebastian

> workarounded by including a 'ping whatever' call in my u-boot env in
> order to force it to do the init. Without it, I was unable to properly
> use the interface. With your fix, after multiple reboots to test it,
> everything works as expected. So, FWIW:
>
> Tested-by: Arnaud Ebalard <arno@natisbad.org>

