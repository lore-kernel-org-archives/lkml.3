Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaIIXRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:17:49 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:12399
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752732AbaIIXRr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:17:47 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Randy Dunlap <rdunlap@infradead.org>, Michael Chan <mchan@broadcom.com>,
        "eddie.wai@broadcom.com" <eddie.wai@broadcom.com>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: RE: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
Thread-Topic: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
Thread-Index: AQHPzDvJUu4bLmC2JEOt957Ln3rhrpv5OvG1gACAmgD//4+vrYAAlBwA//+Nz0Q=
Date: Tue, 9 Sep 2014 23:16:43 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88E3E42@nice.asicdesigners.com>
References: <CA+r1ZhhZynUKSeZnya67z9sph4+tpjO4E7jLZKc0EG4azxFdYA@mail.gmail.com>
	 <525DB349B3FB5444AE057A887CB2A8D88E0BFB@nice.asicdesigners.com>,<1410295676.7520.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <525DB349B3FB5444AE057A887CB2A8D88E3CEC@nice.asicdesigners.com>,<540F8582.50703@infradead.org>
In-Reply-To: <540F8582.50703@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.164.225]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be really good if SCSI_NETLINK depended on NET instead of selected NET.
> We shouldn't have kconfig symbols that use 'select' on entire subsystems.

As a test, I was able to fix this by this approach : change SCSI_NETLINK to depend  
on NET instead of selecting NET, and replacing 'select NETDEVICES ETHERNET 
NET_VENDOR_BROADCOM CNIC' to 'depends on CNIC' in bnx2i & bnx2fc. (as CNIC 
already has a dependency on those). This removes the need to check for IPV6 in 
bnx2i/fc Kconfigs as well.

The side effect is that you won't see BNX2 drivers unless CNIC is selected, similar
for SCSI_NETLINK as well, not sure if there are any other implications.
-Anish