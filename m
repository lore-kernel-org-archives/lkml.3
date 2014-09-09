Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaIIQAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:00:13 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60400 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbaIIQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:00:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v2 5/8] net: pxa168_eth: get and set the mac address on the Ethernet controller
Date: Tue, 09 Sep 2014 17:59:59 +0200
Message-ID: <3876979.iyRVchmjb7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410273848-24663-6-git-send-email-antoine.tenart@free-electrons.com>
References: <1410273848-24663-1-git-send-email-antoine.tenart@free-electrons.com> <1410273848-24663-6-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BRjXBgLI/T1wWUCALi6osPf9WnW6KjfQs4Q1wQ5RouD
 7Fptt8Wk22OB3D5Q3QeCOVl78BV47z+HKw7lGGpr8XTG2pPJms
 3V8bu/6Fck849qxDzeKKB+g4zTFK+2nLEzylJJ9iIJ7DPPCbY6
 InmM9Il1dRcRP5McoYkActWul9AlIG795SS7gGsSM9zwftblC2
 IN4FUEbTPc6g3zo8fuMnuhBtcVnJbvhof2qByXyuWZaEq1ypSz
 rhpuYjC9jaxzLD27AZkkGuDtXG9UpMdT32SnGwj1x0E/d26zZD
 w1KgIxyNJmMgDyvAmgm3O+jopvGgfBMwvMUeMtBNOgCRezm6fT
 C8HIPSPZDvL2FdnxRYOA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 16:44:05 Antoine Tenart wrote:
> When changing the MAC address, in addition to updating the dev_addr in
> the net_device structure, this patch also update the MAC address
> registers (high and low) of the Ethernet controller with the new MAC.
> The address stored in these registers is used for IEEE 802.3x Ethernet
> flow control, which is already enabled.
> 
> This patch also tries reading the MAC address stored in these registers
> when probing the driver, to use the MAC address set by the bootloader
> and avoid using a random one.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> 

I think it would be good to allow overriding the address using a
'mac-address' property from DT. It's very easy to call
of_get_mac_address().

	Arnd
