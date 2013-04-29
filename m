Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab3D2XFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:05:31 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:52636 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab3D2XF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:05:28 -0400
Date: Tue, 30 Apr 2013 01:04:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCHv3 3/3] net: velocity: Add platform device support to VIA
 velocity driver
Message-ID: <20130429230450.GA2620@electric-eye.fr.zoreil.com>
References: <1367264772-4557-1-git-send-email-linux@prisktech.co.nz>
 <1367264772-4557-4-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367264772-4557-4-git-send-email-linux@prisktech.co.nz>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Prisk <linux@prisktech.co.nz> :
[...]
> +static int velocity_remove(void *pdev, enum velocity_bus_type bustype)
> +{
> +	struct net_device *netdev;
> +	struct velocity_info *vptr;
> +	int pci = (bustype == BUS_PCI) ? 1 : 0;
> +
> +	if (pci)
> +		netdev = pci_get_drvdata(pdev);
> +	else
> +		netdev = platform_get_drvdata(pdev);

The caller knows how to retrieve the net_device pointer, whence
the struct velocity_info pointer, whence any bustype dependent
function pointer to alleviate the "if (pci)" and CONFIG stuff.

If you are not convinced, please consider turning the void *
into an union *.

-- 
Ueimor
