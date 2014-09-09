Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaIIVIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:08:22 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:26114
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbaIIVIU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:08:20 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Michael Chan <mchan@broadcom.com>,
        "eddie.wai@broadcom.com" <eddie.wai@broadcom.com>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
Thread-Topic: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
Thread-Index: AQHPzDvJUu4bLmC2JEOt957Ln3rhrpv5OvG1gACAmgD//4+vrQ==
Date: Tue, 9 Sep 2014 21:08:13 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88E3CEC@nice.asicdesigners.com>
References: <CA+r1ZhhZynUKSeZnya67z9sph4+tpjO4E7jLZKc0EG4azxFdYA@mail.gmail.com>
	 <525DB349B3FB5444AE057A887CB2A8D88E0BFB@nice.asicdesigners.com>,<1410295676.7520.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
In-Reply-To: <1410295676.7520.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
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


> Adding depends on IPV6 || IPV6=n doesn't work for SCSI_BNX2X_FCOE, but
> works for SCSI_BNX2_ISCSI?

It fixes the config issue for both, but with FCOE; make scripts will complain about recursive dependencies with the following :

scripts/kconfig/conf --silentoldconfig Kconfig
net/Kconfig:5:error: recursive dependency detected!
net/Kconfig:5:  symbol NET is selected by SCSI_NETLINK
drivers/scsi/Kconfig:43:        symbol SCSI_NETLINK is selected by SCSI_FC_ATTRS
drivers/scsi/Kconfig:258:       symbol SCSI_FC_ATTRS is selected by LIBFC
drivers/scsi/Kconfig:586:       symbol LIBFC is selected by SCSI_BNX2X_FCOE
drivers/scsi/bnx2fc/Kconfig:1:  symbol SCSI_BNX2X_FCOE depends on IPV6
net/ipv6/Kconfig:6:     symbol IPV6 depends on NET


