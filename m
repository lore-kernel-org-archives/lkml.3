Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaA1O2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:28:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44133 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaA1O2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:28:47 -0500
Message-ID: <52E7BE91.8030209@ti.com>
Date: Tue, 28 Jan 2014 19:58:33 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: Arnd Bergmann <arnd@arndb.de>, Mohit Kumar <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Query: Phy: How to find consumer device on dt platform
References: <20140128141356.GC3519@pratyush-vbox>
In-Reply-To: <20140128141356.GC3519@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 28 January 2014 07:43 PM, Pratyush Anand wrote:
> Hi Kishon,
> 
> I have a phy driver which has to be used by two different consumer
> driver, say pcie and sata.

I assume you have multiple instances of the same IP and you have a single
driver for it?
> 
> I have a common set of registers, which need to be programmed
> differently for PCIe and SATA during phy init/exit.

One way is differentiate using different compatible strings fro pcie and sata
and use of_device_is_compatible to select a particular path.
> 
> Therefore, in the init/exit routine of phy_ops, I need some way of
> identifying that phy_init/exit has been called from PCIe driver or
> SATA driver.

In this case you'll be actually registering two different PHYs (each for pcie
and sata), so your phy_get should give you the only the appropriate phy.

Cheers
Kishon
