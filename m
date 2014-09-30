Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaI3Bqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:46:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:52412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaI3Bqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393319377"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "'pure.logic@nexus-software.ie'" <pure.logic@nexus-software.ie>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "davej@redhat.com" <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] x86: Quark: Add if/else to setup_arch for Quark TLB
 bug
Thread-Topic: [PATCH v2] x86: Quark: Add if/else to setup_arch for Quark TLB
 bug
Thread-Index: AQHP2bMQNyIt2xdKHE23Rec7de2uWZwTYCOAgAAICgCABYOH4A==
Date: Tue, 30 Sep 2014 01:46:04 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B73259A4FF@pgsmsx105.gar.corp.intel.com>
References: <1411754118-11665-1-git-send-email-pure.logic@nexus-software.ie>
 <20140926205955.GA22407@khazad-dum.debian.net>
 <5425DA8A.1030500@nexus-software.ie>
In-Reply-To: <5425DA8A.1030500@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> My view is that the CR3 load should have flushed the TLB in it's entirety.
> 
> Ong Boong Leong said that a discussion he had which included HPA concluded
> with a flush of the TLB being required after the CR3 reload.

The proposed patch was discussed in April and after much thought into this,
I will suggest that as long as the commentary properly captured down why
__flush_tlb() is **NOT** needed because load_cr3() will have the same effect.

> 
> The current code
> 
> My preference is
> 
> 1. Just comment the code as is to explain why it works for Quark.
> 
> If that's not good enough for people then
> 
> 2. if/else the flow so that Quark does __flush_tlb() and the rest of the world
> does a __flush_tlb_all()
Bryan, just drop this proposal from my submission even though __flush_tlb() is
more obvious in what is supposed to do and does not consume any significant cpu-time.


