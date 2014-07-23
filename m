Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbaGWPym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:54:42 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:15117
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756924AbaGWPyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:54:40 -0400
From: Karen Xie <kxie@chelsio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anish Bhatt <anish@chelsio.com>,
        Manoj Malviya <manojmalviya@chelsio.com>,
        "Hannes Reinecke" <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: RE: linux-next: manual merge of the scsi tree with the net-next tree
Thread-Topic: linux-next: manual merge of the scsi tree with the net-next
 tree
Thread-Index: AQHPpkESJGweCoS5WEePwS4hjc9+aJut0BvP
Date: Wed, 23 Jul 2014 15:54:27 +0000
Message-ID: <1442C3287A121140B690F7F20F94463D05BB32@nice.asicdesigners.com>
References: <20140723164049.413272e8@canb.auug.org.au>
In-Reply-To: <20140723164049.413272e8@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [67.207.112.58]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, thanks a lot!
________________________________________
From: Stephen Rothwell [sfr@canb.auug.org.au]
Sent: Tuesday, July 22, 2014 11:40 PM
To: James Bottomley; David Miller; netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Anish Bhatt; Karen Xie; Manoj Malviya; Hannes Reinecke; Christoph Hellwig
Subject: linux-next: manual merge of the scsi tree with the net-next tree

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
drivers/scsi/cxgbi/libcxgbi.h between commit fc8d0590d914 ("libcxgbi:
Add ipv6 api to driver") from the net-next tree and commit 1abf635d2f33
("scsi: use 64-bit value for 'max_luns'") from the scsi tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/cxgbi/libcxgbi.h
index 8ad73d913f02,538d7a64e138..000000000000
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@@ -708,8 -692,7 +708,8 @@@ struct cxgbi_device *cxgbi_device_regis
  void cxgbi_device_unregister(struct cxgbi_device *);
  void cxgbi_device_unregister_all(unsigned int flag);
  struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
 +struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *, int *);
- int cxgbi_hbas_add(struct cxgbi_device *, unsigned int, unsigned int,
+ int cxgbi_hbas_add(struct cxgbi_device *, u64, unsigned int,
                        struct scsi_host_template *,
                        struct scsi_transport_template *);
  void cxgbi_hbas_remove(struct cxgbi_device *);
