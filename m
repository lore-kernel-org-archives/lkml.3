Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbaCTWII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:08:08 -0400
Received: from mail-bn14138.inbound.protection.outlook.com ([207.46.163.138]:59120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759829AbaCTWIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:08:06 -0400
Message-ID: <1395353279.12479.335.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: "'Kevin Hao'" <haokexin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Chenhui Zhao <chenhui.zhao@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Mar 2014 17:07:59 -0500
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6E33AE@AcuExch.aculab.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
	 <1394646185.13761.145.camel@snotra.buserror.net>
	 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
	 <1394835987.12479.119.camel@snotra.buserror.net>
	 <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
	 <1395184734.12479.250.camel@snotra.buserror.net>
	 <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6E33AE@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR08CA005.namprd08.prod.outlook.com (10.255.197.35) To
 BL2PR03MB388.namprd03.prod.outlook.com (10.141.91.153)
X-Forefront-PRVS: 01565FED4C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377424004)(51704005)(24454002)(95416001)(94946001)(76482001)(86362001)(93916002)(50226001)(89996001)(50986001)(47976001)(56776001)(54316002)(79102001)(90146001)(56816005)(88136002)(4396001)(46102001)(49866001)(80022001)(93136001)(92566001)(76796001)(77156001)(92726001)(47736001)(81542001)(77982001)(94316002)(47446002)(74502001)(50466002)(74366001)(31966008)(74876001)(77096001)(74706001)(81686001)(74662001)(81816001)(59766001)(33646001)(85306002)(95666003)(51856001)(69226001)(83322001)(87976001)(87266001)(87286001)(93516002)(85852003)(47776003)(83072002)(42186004)(53806001)(76786001)(62966002)(23676002)(63696002)(20776003)(65816001)(81342001)(80976001)(97336001)(97186001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB388;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:7415F695.4BFE43C8.F2D5178C.40D75AB1.201E6;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 11:59 +0000, David Laight wrote:
> I tried to work out what the 'twi, isync' instructions were for (in in_le32()).
> The best I could come up with was to ensure a synchronous bus-fault.
> But bus faults are probably only expected during device probing - not
> normal operation, and the instructions will have a significant cost.
> 
> Additionally in_le32() and out_le32() both start with a 'sync' instruction.
> In many cases that isn't needed either - an explicit iosync() can be
> used after groups of instructions.

The idea is that it's better to be maximally safe by default, and let
performance critical sections be optimized using raw accessors and
explicit synchronization if needed, than to have hard-to-debug bugs due
to missing/wrong sync.  A lot of I/O is slow enough that the performance
impact doesn't really matter, but the brain-time cost of getting the 
sync right is still there.

-Scott


