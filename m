Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3BSKn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:43:59 -0500
Received: from mx0.aculab.com ([213.249.233.131]:42284 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932549Ab3BSKn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:43:56 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v6 08/46] CPU hotplug: Provide APIs to prevent CPU offline from atomic context
Date: Tue, 19 Feb 2013 10:42:53 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7154@saturn3.aculab.com>
In-Reply-To: <51234C23.2030909@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v6 08/46] CPU hotplug: Provide APIs to prevent CPU offline from atomic context
Thread-Index: Ac4Oh46eRPshRGTaQ5WguP6C41i24AABWy2w
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com> <20130218123920.26245.56709.stgit@srivatsabhat.in.ibm.com> <CANN689HhVxDv+3Bn9UAxOMzj0egTvVp_c7oAmQ2nnQ8Xjn_aMA@mail.gmail.com> <51225A36.40600@linux.vnet.ibm.com> <CANN689FJPLfz06MFRJ9T+BuToejAzjYP_yrw_H4iGi1Kb3p2-g@mail.gmail.com> <51227810.6090009@linux.vnet.ibm.com> <CANN689E-98zK69pGeojbm30n3sswQYVBvhk3i3OzqvbeqSrSrg@mail.gmail.com> <51234C23.2030909@linux.vnet.ibm.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Michel Lespinasse" <walken@google.com>
Cc: <tglx@linutronix.de>, <peterz@infradead.org>, <tj@kernel.org>,
        <oleg@redhat.com>, <paulmck@linux.vnet.ibm.com>,
        <rusty@rustcorp.com.au>, <mingo@kernel.org>,
        <akpm@linux-foundation.org>, <namhyung@kernel.org>,
        <rostedt@goodmis.org>, <wangyun@linux.vnet.ibm.com>,
        <xiaoguangrong@linux.vnet.ibm.com>, <rjw@sisk.pl>, <sbw@mit.edu>,
        <fweisbec@gmail.com>, <linux@arm.linux.org.uk>,
        <nikunj@linux.vnet.ibm.com>, <linux-pm@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wouldn't go that far... ;-) Unfairness is not a show-stopper right?
> IMHO, the warning/documentation should suffice for anybody wanting to
> try out this locking scheme for other use-cases.

I presume that by 'fairness' you mean 'write preference'?

I'd not sure how difficult it would be, but maybe have two functions
for acquiring the lock for read, one blocks if there is a writer
waiting, the other doesn't.

That way you can change the individual call sites separately.

The other place I can imagine a per-cpu rwlock being used
is to allow a driver to disable 'sleep' or software controlled
hardware removal while it performs a sequence of operations.

	David



