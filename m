Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaJIPYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:24:49 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36845 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaJIPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:24:40 -0400
Message-ID: <5436A8B2.1030200@gmail.com>
Date: Thu, 09 Oct 2014 17:24:34 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFT 0/8] Marvell PXA168 libphy handling and Berlin Ethernet
References: <1412858346-11334-1-git-send-email-sebastian.hesselbarth@gmail.com> <20141009163315.2a9e1806@free-electrons.com> <54369EAC.5040301@gmail.com> <20141009164704.7286fc3f@free-electrons.com>
In-Reply-To: <20141009164704.7286fc3f@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 04:47 PM, Thomas Petazzoni wrote:
> Well, I initially remember that the original driver coming from Marvell
> was using the HW PHY stuff, and that I changed that because it would
> not integrate well with the kernel libphy.
>
> A drawback of this is that because the hardware has built-in PHY
> polling which triggers a MAC interrupt when the PHY status changes, they
> typically don't wire up the PHY interrupt. Therefore, since we're not
> able to use the MAC interrupt for PHY event notifications, we rely on
> software PHY polling, which means that link up / link down events take
> a few seconds to be noticed by the kernel. Unfortunately, I don't think
> the hardware allows to use the hardware PHY polling to get link changes
> interrupt, but not let the hardware configure the PHY itself.

Yeah, but that HW PHY stuff really only works properly with standard
compliant PHYs. In particular, the integrated Marvell PHY in Marvell
Berlin SoCs does not seem to reflect PHY status on BMCR properly /sigh/.
Anyway, I think we can live with PHY polling.

BTW, one thing I noticed here is that libphy calls adjust_link
over-and-over again although nothing has changed. I guess we can just
add some before/after comparison in the libphy state machine and only
call adjust_link when something has changed. I'll have to look closer
at the state machine first and maybe Florian can comment on this,
too.

Sebastian

