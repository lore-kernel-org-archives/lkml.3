Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaBKSdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:33:19 -0500
Received: from [207.46.163.188] ([207.46.163.188]:48979 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751803AbaBKSdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:33:17 -0500
Message-ID: <1392143455.6733.386.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Scott Wood <scottwood@freescale.com>
To: Torsten Duwe <duwe@lst.de>
CC: Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, "Anton Blanchard" <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Tom Musta" <tommusta@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 12:30:55 -0600
In-Reply-To: <20140211104030.GG2107@lst.de>
References: <20140207165801.GC2107@lst.de>
	 <1392001823.3996.21.camel@pasglop>
	 <CAC4Lta2Pssu5QY_QLmy5C3Fm2G3fwpiuc5BNOLBnQTmmRH+W4Q@mail.gmail.com>
	 <20140211104030.GG2107@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR01CA009.prod.exchangelabs.com (10.141.66.49) To
 BLUPR03MB391.namprd03.prod.outlook.com (10.141.78.21)
X-Forefront-PRVS: 0119DC3B5E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(199002)(189002)(24454002)(51704005)(89996001)(90146001)(56816005)(88136002)(76482001)(50986001)(46102001)(53806001)(42186004)(47976001)(94946001)(83072002)(74662001)(95416001)(77156001)(56776001)(4396001)(49866001)(92566001)(92726001)(51856001)(33646001)(80976001)(83322001)(47736001)(81816001)(81686001)(23676002)(77096001)(86362001)(31966008)(76796001)(54316002)(74502001)(47446002)(93916002)(94316002)(76786001)(93516002)(85852003)(93136001)(50226001)(77982001)(62966002)(81542001)(79102001)(81342001)(59766001)(63696002)(50466002)(74366001)(69226001)(74876001)(80022001)(85306002)(87286001)(87266001)(87976001)(74706001)(65816001)(95666001)(47776003)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB391;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:BEEAF494.AC22371D.E8DCB388.C8EF9B3E.201E8;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 11:40 +0100, Torsten Duwe wrote:
> On Tue, Feb 11, 2014 at 03:23:51PM +0530, Raghavendra KT wrote:
> > How much important to have holder information for PPC? From my
> > previous experiment
> > on x86, it was lock-waiter preemption which is problematic rather than
> > lock-holder preemption.
> 
> It's something very special to IBM pSeries: the hypervisor can assign
> fractions of physical CPUs to guests. Sometimes a guest with 4 quarter
> CPUs will be faster than 1 monoprocessor. (correct me if I'm wrong).
> 
> The directed yield resolves the silly situation when holder and waiter
> reside on the same physical CPU, as I understand it.
> 
> x86 has nothing comparable.

How is this different from the very ordinary case of an SMP KVM guest
whose vcpus are not bound to host cpus, and thus you could have multiple
vcpus running on the same host cpu?

-Scott


