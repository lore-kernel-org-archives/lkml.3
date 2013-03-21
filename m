Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3CUUPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:15:50 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51000 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3CUUPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:15:48 -0400
Date: Thu, 21 Mar 2013 21:15:33 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Message-ID: <20130321201533.GN21478@lunn.ch>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
 <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  		/*
> -		 * 4 GB of plug-in RAM modules by default but only 3GB
> -		 * are visible, the amount of memory available can be
> -		 * changed by the bootloader according the size of the
> -		 * module actually plugged
> +		 * 8 GB of plug-in RAM modules by default.The amount
> +		 * of memory available can be changed by the
> +		 * bootloader according the size of the module
> +		 * actually plugged. Only 7GB are usable because
> +		 * addresses from 0xC0000000 to 0xffffffff are used by
> +		 * the internal registers of the SoC.
>  		 */
> -		reg = <0x00000000 0xC0000000>;
> +		reg = <0x00000000 0x00000000 0x00000000 0xC0000000>,
> +		      <0x00000001 0x00000000 0x00000001 0x00000000>;
> +

Hi Gregory

Could you recommend a document which introduces LPAE.

Only being able to address 7GB seems a bit odd to me. I kind of
expected you set up the translation tables to map a page in the 32 bit
address range to any arbitrary page in the 40 bit address range. So
leaving 0xC0000000 to 0xffffffff in the 32bit address range clear is
easy. But why do you loose space in the 40bit address range?

      Thanks
	Andrew
