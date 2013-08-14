Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab3HNJZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:25:09 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34332 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3HNJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:25:05 -0400
Message-ID: <520B4CEE.2050508@gmail.com>
Date: Wed, 14 Aug 2013 11:25:02 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] PCI: mvebu: add support for reset on GPIO
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com> <20130814090715.GA2084@ulmo>
In-Reply-To: <20130814090715.GA2084@ulmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 11:07 AM, Thierry Reding wrote:
> On Tue, Aug 13, 2013 at 02:25:23PM +0200, Sebastian Hesselbarth wrote:
> [...]
>> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> [...]
>> @@ -897,6 +904,30 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
> [...]
>> +			u32 reset_udelay = 20000;
> [...]
>> +			udelay(reset_udelay);
>
> udelay(20000) is probably not a good idea. You should probably use
> something like usleep_range() or msleep() here. Also see:
>
> 	Documentation/timers/timers-howto.txt

Thierry,

thanks for mentioning this. I clearly got distracted from ms to us
switch due to the different reset API convention. As the delay will
be most likely 10ms+, we should change the above to
msleep(reset_udelay/1000) instead.

Sebastian
