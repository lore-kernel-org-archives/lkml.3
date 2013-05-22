Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3EVJnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:43:25 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36697 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3EVJnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:43:21 -0400
Message-ID: <519C9333.20609@gmail.com>
Date: Wed, 22 May 2013 11:43:15 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio device
 tree nodes
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130521174849.GL26249@lunn.ch>
In-Reply-To: <20130521174849.GL26249@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 07:48 PM, Andrew Lunn wrote:
> On Tue, May 21, 2013 at 06:41:44PM +0200, Sebastian Hesselbarth wrote:
>> This patch adds orion-eth and mvmdio device tree nodes for DT enabled
>> Dove boards. As there is only one ethernet controller on Dove, a default
>> phy node is also added with a note to set its reg property on a per-board
>> basis.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>> ---
...
>> +			ethernet-port@0 {
>> +				device_type = "network";
>> +				compatible = "marvell,orion-eth-port";
>> +				reg =<0>;
>> +				interrupts =<29>;
>> +				/* overwrite MAC address in bootloader */
>> +				local-mac-address = [00 00 00 00 00 00];
>
> Hi Sebastian
>
> Its probably a good idea to set the local administration bit in this
> MAC address. i.e. first byte is 02.

Andrew,

we just need an invalid address here to trigger the default behavior of
the driver and load the MAC address from its register. As PPC binding
documentation also has all zero, I just took it.

Sebastian
