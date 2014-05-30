Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaE3KXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:23:05 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:57959
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755275AbaE3KXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:23:03 -0400
Date: Fri, 30 May 2014 17:01:30 +0800
From: Huang Shijie <b32955@freescale.com>
To: "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>
Subject: Re: [PATCH 1/2] serial: imx: remove the DMA wait queue
Message-ID: <20140530090128.GA4380@shlinux1.ap.freescale.net>
References: <1400819575-20435-1-git-send-email-b32955@freescale.com>
 <857E9EDCA6C0904DB3357321AA9123EBE14B5A2C@NA-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <857E9EDCA6C0904DB3357321AA9123EBE14B5A2C@NA-MBX-03.mgc.mentorg.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(24454002)(199002)(51704005)(50986999)(99396002)(76482001)(76176999)(83072002)(6806004)(80022001)(74502001)(83322001)(47776003)(84676001)(97736001)(44976005)(79102001)(104016001)(26826002)(31966008)(23726002)(64706001)(97756001)(68736004)(33656002)(85852003)(50466002)(81342001)(81542001)(74662001)(92566001)(21056001)(54356999)(92726001)(46102001)(87936001)(102836001)(77096999)(77982001)(20776003)(83506001)(4396001)(46406003)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB367;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02272225C5
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:27:20AM +0000, Wang, Jiada (ESD) wrote:
> Hi Shijie
> 
> After apply this patch into our kernel,
> We are facing data hang issue when sending big size file (2M used in test) to uart port
> Note: Rx port is also keep receiving data.
> 
> After read the implementation of uart_stop(),
> I feel like, stop_tx() is used to perform flow control when like a XOFF is received.
> Which means no data should be dropped, as they may need to be sent out,
> When next start_tx() is called.
> 
> But by calling dmaengine_termiate_all(), the data already be submitted to DMA engine,
> May be lost, thus cause data hang.
> 
> What do you think?
This patch has been reverted by Greg.

I also noticed the data loss issue. 

thanks
Huang Shijie
