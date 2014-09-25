Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaIYDDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:03:02 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:16082 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaIYDC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:02:59 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Tejun Heo <tj@kernel.org>, Alexander Gordeev <agordeev@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: RE: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Thread-Topic: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Thread-Index: AQHP1Z7naJZpR+SLn0GNa06SNvgNsJwPNqQAgADmh4CAACfPAIAA4Y5g
Date: Thu, 25 Sep 2014 03:00:58 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9C5C7@G9W0745.americas.hpqcorp.net>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
In-Reply-To: <20140924130444.GA16555@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.192.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Tejun Heo
...
> The thing I don't get is why multiple MSI handling and this patchset
> are tied to threaded interrupt handling.  Splitting locks don't
> necessarily have much to do with threaded handling and it's not like
> ahci interrupt handling is heavy.  The hot path is pretty short
> actually.  The meat of the work - completing requests and propagating
> completions - is offloaded to softirq by block layer anyway.

blk-mq/scsi-mq chose to move all completion work into hardirq context,
so this seems headed in a different direction.


