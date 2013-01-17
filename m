Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3AQTGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:06:03 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2758 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab3AQTGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:06:00 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Subject: Re: tg3 v3.123 in 100Mbps Full-Duplex mode with autoneg off
From: "Michael Chan" <mchan@broadcom.com>
To: "Marcin Miotk" <marcinmiotk81@gmail.com>
cc: =?UTF-8?Q?=E7=8E=8B=E9=87=91=E6=B5=A6?= <jinpuwang@gmail.com>,
        nsujir@broadcom.com, "Benjamin Li" <benli@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAMXyS3PBAOraPTYRW9BSmoccVWAuY0RzZNgKe-L4Z3WHQDDgbA@mail.gmail.com>
References: <CAMXyS3Mvc8SkJxu4fCcUn+XpNcHrzEQ=M5w2eenVr-YKwa3AEQ@mail.gmail.com>
 <CAMXyS3MRx3D__60xtt4G4CCyHSTW2iHd1x1AR1LCQkrZrOiJ2g@mail.gmail.com>
 <CAD9gYJL1GjZtPuEWozmgM37NzhJeAO1Oe69Tnzxi5bCPMijmcA@mail.gmail.com>
 <1357703565.7140.217.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CAMXyS3PhStKo_xeiTRH+kbZXNUcwmMvrvTHrDOR-6qkuUCVH2A@mail.gmail.com>
 <1358206365.4596.23.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <CAMXyS3PBAOraPTYRW9BSmoccVWAuY0RzZNgKe-L4Z3WHQDDgbA@mail.gmail.com>
Date: Thu, 17 Jan 2013 11:04:17 -0800
Message-ID: <1358449457.4596.64.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7CE695DF3Q43611456-15-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 17:59 +0100, Marcin Miotk wrote:
> root@XXXXXX ~ # cat miitool_non_working_3.4.11
> Using SIOCGMIIPHY=0x8947
> eth1: 100 Mbit, full duplex, no link
>   registers for MII PHY 1:
>     2100 7949 0020 6340 0041 0000 0004 2001
>     0000 0000 0000 0000 0000 0000 0000 3000
>     0001 2000 0000 0000 0000 0000 0000 4000
>     7277 1000 0000 ffff 2801 0000 0000 0000
>   product info: vendor 00:08:18, model 52 rev 0
>   basic mode:   100 Mbit, full duplex
>   basic status: no link
>   capabilities: 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   advertising:  10baseT-FD

Autoneg is disabled, so the advertising register that is advertising
only 10Mbps Full Duplex should not matter.  What matters is that
register 0 has set it to 100Mbps Full Duplex.
> 
> 
> What looks suspicious here is the last line of mii-tool output:
> 'advertising: 10baseT-FD', while only 100baseTx-FD is set on a switch.
> 'mii-tool -vvv eth1' on working 3.0.9 gives output like below:
> 
> root@XXX ~ # cat miitool_working_3.0.9
> Using SIOCGMIIPHY=0x8947
> eth1: 100 Mbit, full duplex, link ok
>   registers for MII PHY 1:
>     2100 794d 0020 6340 0501 0000 0004 2001
>     0000 0000 0000 0000 0000 0000 0000 3000
>     0001 0301 0000 0000 0000 0000 0000 4000
>     7277 0504 0000 ffff 2801 0000 0000 0000
>   product info: vendor 00:08:18, model 52 rev 0
>   basic mode:   100 Mbit, full duplex
>   basic status: link ok
>   capabilities: 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   advertising:  100baseTx-FD flow-control
> 
In the working case, register 0 where it matters is the same (autoneg
disabled and 100Mbps Full Duplex).  Register 4 happens to advertise the
same 100 Mbps Full duplex forced speed, and apparently your link partner
cares about that, which is very strange because autoneg is disabled.

There apparently has been a change in behavior in the tg3 code, but
again it should not matter.  The 3.7 kernel that I tested on behaved the
same as your non-working case but it worked for me.  I guess I can try
to restore the original behavior.  I'll need time to look through all
the changes.




