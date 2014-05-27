Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaE0NoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:44:07 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:10792
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbaE0NoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:44:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Bernhard Walle <bernhard@bwalle.de>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression in hyperv network driver in 3.14
Thread-Topic: Regression in hyperv network driver in 3.14
Thread-Index: AQHPeZw4JYywpuXdR0qHVYHBXHThyJtUb4mw
Date: Tue, 27 May 2014 13:43:46 +0000
Message-ID: <25b90b45e3284715ab0ab00cb812a99f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140527111003.GA2214@kepler.fritz.box>
In-Reply-To: <20140527111003.GA2214@kepler.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:e80d:87dd:40a8:a05b]
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(13464003)(51704005)(377454003)(101416001)(99286001)(99396002)(46102001)(77982001)(2656002)(74316001)(79102001)(77096999)(87936001)(21056001)(86362001)(33646001)(80022001)(19580405001)(54356999)(74502001)(1511001)(83322001)(64706001)(92566001)(81542001)(20776003)(50986999)(76482001)(86612001)(74662001)(76176999)(19580395003)(83072002)(4396001)(31966008)(76576001)(81342001)(85852003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Bernhard Walle [mailto:bernhard@bwalle.de]
> Sent: Tuesday, May 27, 2014 4:10 AM
> To: Haiyang Zhang
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org
> Subject: Regression in hyperv network driver in 3.14
> 
> Hello,
> 
> using a 3.14 kernel in a Linux VM running on HyperV (Windows Server 2008
> R2) we get following error:
> 
>    hv_netvsc: hv_netvsc channel opened successfully
>    hv_netvsc vmbus_0_9 (unregistered net_device): Unable to complete
> receive buffer initialization with NetVsp - status 2
>    hv_netvsc vmbus_0_9 (unregistered net_device): unable to connect to
> NetVSP - -22
>    hv_netvsc vmbus_0_9 (unregistered net_device): unable to add netvsc
> device (ret -22)
>    hv_netvsc: probe of vmbus_0_9 failed with error -22
> 
> Bisecting the problem shows that commit
> b679ef73edc251f6d200a7dd2396e9fef9e36fc3 is responsible. Reverting it
> fixes the issue. Even only changing NETVSC_RECEIVE_BUFFER_SIZE to 2M
> fixes the issue!
> 
> The virtual machine has 2 GiB of memory and 4 CPUs.
> 
> Can I provide more information to track down the problem?

This bug has been fixed upstream. The issue is with regards to the older hosts (ws2008 r2) not
Being able to handle the larger receive buffer currently used.

K. Y
> 
> 
> Regards,
> Bernhard

