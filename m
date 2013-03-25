Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3CYGYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:24:08 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34625 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3CYGYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:24:06 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r2P6NiEk011942, This message is released by code: ctlocs8528
Message-ID: <514FED71.8020307@realsil.com.cn>
Date: Mon, 25 Mar 2013 14:23:45 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <cjb@laptop.org>, <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rogerable@realtek.com>, <devel@linuxdriverproject.org>
Subject: Re: [PATCH] mfd:rtsx: Support RTS5249
References: <1364177636-4294-1-git-send-email-wei_wang@realsil.com.cn> <20130325060038.GD9138@mwanda>
In-Reply-To: <20130325060038.GD9138@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月25日 14:00, Dan Carpenter 写道:
> On Mon, Mar 25, 2013 at 10:13:56AM +0800, wei_wang@realsil.com.cn wrote:
>> +static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>> +{
>> +	int err;
>> +
>> +	err = rtsx_pci_write_phy_register(pcr, 0x19, 0xFE46);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	mdelay(1);
> Why do we have the mdelay() and the later msleep(5)?
> rtsx_pci_write_phy_register() busy loops until the write succeeds or
> it returns -ETIMEOUT.  The extra wait here seems unnecessary.
>
> regards,
> dan carpenter
>
>
> .
>   

Hi,

The busy loops in rtsx_pci_write_phy_register only tell us that the 
write sequence succeeds. The device still needs to wait for a while 
until the internal signal stable. Or else the timing won't fit the 
requirement.
All of the delays in the driver are necessary.

BR,
Wei
