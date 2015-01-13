Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbbAMPC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:02:29 -0500
Received: from smtp-out4.electric.net ([192.162.216.185]:55873 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbAMPC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:02:27 -0500
X-Greylist: delayed 18699 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 10:02:26 EST
From: David Laight <David.Laight@ACULAB.COM>
To: "'Thomas Graf'" <tgraf@suug.ch>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] rhashtable: Lower/upper bucket may map to same
 lock while shrinking
Thread-Topic: [PATCH net-next] rhashtable: Lower/upper bucket may map to
 same lock while shrinking
Thread-Index: AQHQLsOaDcPAoa7KRUCgwuw0+9z8NJy9zZiggAAcC4CAADsX4A==
Date: Tue, 13 Jan 2015 15:00:54 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAC6946@AcuExch.aculab.com>
References: <20150112232217.GA5277@wfg-t540p.sh.intel.com>
 <20150112235821.GB16617@casper.infradead.org>
 <063D6719AE5E284EB5DD2968C1650D6D1CAC6593@AcuExch.aculab.com>
 <20150113112507.GH20387@casper.infradead.org>
In-Reply-To: <20150113112507.GH20387@casper.infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf
...
> > Thought, could the shrunk table use the same locks as the lower half
> > of the old table?
> 
> No. A new bucket table and thus a new set of locks is allocated when the
> table is shrunk or grown. We only have check for overlapping locks
> when holding multiple locks for the same table at the same time.

I was guessing that when locks are shared buckets k and 2^n+k use the
same lock.
Under those conditions if the 'grow' decided not to allocate extra
locks then it could save work by using exactly the same locks as the
old table.
Similarly 'shrink' could do the reverse.

It was only a thought.

	David

