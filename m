Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3CSRE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:04:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42654 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab3CSRE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:04:57 -0400
Message-ID: <51489A99.2030107@ti.com>
Date: Tue, 19 Mar 2013 22:34:25 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <aeschlimann@gmail.com>, <khc@pm.waw.pl>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <c.aeschlimann@acn-group.ch>
Subject: Re: [PATCH] ixp4xx_eth: set the device dma_coherent_mask
References: <1363708765-20778-1-git-send-email-c.aeschlimann@acn-group.ch> <20130319.123359.2245221095583640859.davem@davemloft.net>
In-Reply-To: <20130319.123359.2245221095583640859.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/2013 10:03 PM, David Miller wrote:
> From: Christophe Aeschlimann<aeschlimann@gmail.com>
> Date: Tue, 19 Mar 2013 16:59:25 +0100
>
>> >Without the mask it is impossible to take the network interface up
>> >since it returns the following error:
>> >
>>> >>net eth1: coherent DMA mask is unset
>>> >>ifconfig: SIOCSIFFLAGS: Cannot allocate memory
>> >
>> >Tested on an out-of-tree ixp425 based board.
>> >
>> >Signed-off-by: Christophe Aeschlimann<c.aeschlimann@acn-group.ch>
>   ...
>> >@@ -1398,6 +1398,7 @@ static int eth_init_one(struct platform_device *pdev)
>> >  		return -ENOMEM;
>> >  
>> >  	SET_NETDEV_DEV(dev, &pdev->dev);
>> >+	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> Hmmm, shouldn't this be the default value, set by the bus layer or
> similar?
bus layer or any platform code doesn't init this value. The same issue 
applies
to CPSW driver also. Previously the same was done in board or device 
file. But
this approach is obsolete now, need to think of how it can be resolved in DT
approach

Regards
Mugunthan V N
