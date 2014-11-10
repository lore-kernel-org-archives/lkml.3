Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaKJG1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:27:23 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:5658 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKJG1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:27:21 -0500
From: Anish Bhatt <anish@chelsio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Karen Xie <kxie@chelsio.com>
Subject: RE: linux-next: build failure after merge of the scsi tree
Thread-Topic: linux-next: build failure after merge of the scsi tree
Thread-Index: AQHP/K6J8i3rGWaZTEqyAMXQFzemVJxZZGyZ
Date: Mon, 10 Nov 2014 06:27:13 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8D71B12@nice.asicdesigners.com>
References: <20141110171533.63b2dfcc@canb.auug.org.au>
In-Reply-To: <20141110171533.63b2dfcc@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.150]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for this was sent out on thursday itself, but does not seem to be applied yet :
http://marc.info/?l=linux-scsi&m=141529629911520&w=2
________________________________________
From: Stephen Rothwell [sfr@canb.auug.org.au]
Sent: Sunday, November 09, 2014 10:15 PM
To: James Bottomley
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Anish Bhatt; Christoph Hellwig; Karen Xie
Subject: linux-next: build failure after merge of the scsi tree

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c: In function 'do_abort_req_rss':
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:942:3: error: too many arguments to function 'send_tx_flowc_wr'
   send_tx_flowc_wr(csk, 0);
   ^
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:492:20: note: declared here
 static inline void send_tx_flowc_wr(struct cxgbi_sock *csk)
                    ^

Caused by commit 4be50d4f7649 ("cxgb4i: send abort_rpl correctly").

I have used the scsi tree from next-20141106 for today.
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
