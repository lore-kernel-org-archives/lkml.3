Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3AQQ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:59:20 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56022 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3AQQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:59:18 -0500
MIME-Version: 1.0
In-Reply-To: <1358206365.4596.23.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <CAMXyS3Mvc8SkJxu4fCcUn+XpNcHrzEQ=M5w2eenVr-YKwa3AEQ@mail.gmail.com>
	<CAMXyS3MRx3D__60xtt4G4CCyHSTW2iHd1x1AR1LCQkrZrOiJ2g@mail.gmail.com>
	<CAD9gYJL1GjZtPuEWozmgM37NzhJeAO1Oe69Tnzxi5bCPMijmcA@mail.gmail.com>
	<1357703565.7140.217.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<CAMXyS3PhStKo_xeiTRH+kbZXNUcwmMvrvTHrDOR-6qkuUCVH2A@mail.gmail.com>
	<1358206365.4596.23.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Date: Thu, 17 Jan 2013 17:59:17 +0100
Message-ID: <CAMXyS3PBAOraPTYRW9BSmoccVWAuY0RzZNgKe-L4Z3WHQDDgbA@mail.gmail.com>
Subject: Re: tg3 v3.123 in 100Mbps Full-Duplex mode with autoneg off
From: Marcin Miotk <marcinmiotk81@gmail.com>
To: Michael Chan <mchan@broadcom.com>
Cc: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>, nsujir@broadcom.com,
        Benjamin Li <benli@broadcom.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

thx for your reply, here is the info you requested:

> 1. ethtool eth0 with a working kernel.  I'd like to see the MDI-X
> setting when it is working.

root@XXXXXX ~ # cat ethtool_working_3.0.9
Settings for eth1:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Half 1000baseT/Full
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Speed: 100Mb/s
	Duplex: Full
	Port: Twisted Pair
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: off
	MDI-X: Unknown
	Supports Wake-on: g
	Wake-on: g
	Current message level: 0x000000ff (255)
			       drv probe link timer ifdown ifup rx_err tx_err
	Link detected: yes


> 2. mii-tool -vvv eth0 with the non-working kernel.

root@XXXXXX ~ # cat miitool_non_working_3.4.11
Using SIOCGMIIPHY=0x8947
eth1: 100 Mbit, full duplex, no link
  registers for MII PHY 1:
    2100 7949 0020 6340 0041 0000 0004 2001
    0000 0000 0000 0000 0000 0000 0000 3000
    0001 2000 0000 0000 0000 0000 0000 4000
    7277 1000 0000 ffff 2801 0000 0000 0000
  product info: vendor 00:08:18, model 52 rev 0
  basic mode:   100 Mbit, full duplex
  basic status: no link
  capabilities: 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  10baseT-FD


What looks suspicious here is the last line of mii-tool output:
'advertising: 10baseT-FD', while only 100baseTx-FD is set on a switch.
'mii-tool -vvv eth1' on working 3.0.9 gives output like below:

root@XXX ~ # cat miitool_working_3.0.9
Using SIOCGMIIPHY=0x8947
eth1: 100 Mbit, full duplex, link ok
  registers for MII PHY 1:
    2100 794d 0020 6340 0501 0000 0004 2001
    0000 0000 0000 0000 0000 0000 0000 3000
    0001 0301 0000 0000 0000 0000 0000 4000
    7277 0504 0000 ffff 2801 0000 0000 0000
  product info: vendor 00:08:18, model 52 rev 0
  basic mode:   100 Mbit, full duplex
  basic status: link ok
  capabilities: 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  100baseTx-FD flow-control

Any ideas?

Regards,
Marcin
