Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaIIUsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:48:05 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9299 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaIIUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:48:03 -0400
X-IronPort-AV: E=Sophos;i="5.04,493,1406617200"; 
   d="scan'208";a="45178467"
Subject: RE: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
From: Michael Chan <mchan@broadcom.com>
To: Anish Bhatt <anish@chelsio.com>, <eddie.wai@broadcom.com>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D88E0BFB@nice.asicdesigners.com>
References: <CA+r1ZhhZynUKSeZnya67z9sph4+tpjO4E7jLZKc0EG4azxFdYA@mail.gmail.com>
	 <525DB349B3FB5444AE057A887CB2A8D88E0BFB@nice.asicdesigners.com>
Content-Type: text/plain; charset="cp1252"
Date: Tue, 9 Sep 2014 13:47:56 -0700
Message-ID: <1410295676.7520.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 20:24 +0000, Anish Bhatt wrote: 
> This is caused by c99d667e8527  ("cnic : Cleanup CONFIG_IPV6 & VLAN check")
> 
> So I'm not really sure what the fix for this is. CNIC will properly only support 
> [m] or [n] when IPV6 is compiled as a module, but if you set SCSI_BNX2X_FCOE or 
> SCSI_BNX2_ISCSI to be in built, there is a 'select CNIC' that forces CNIC to be 
> inbuilt, even though this is not supported by Kconfig. I was under the 
> assumption that select will not forcibly change m to inbuilt (or perhaps I'm 
> missing some syntax suboption ?)
> 
> This is still fixable in SCSI_BNX2_ISCSI using the same logic used in the above 
> mentioned commit, but not so in SCSI_BNX2X_FCOE where it causes a recursive 
> dependency error (thought it is fixing the issue nevertheless), and none of the 
>  other solutions I tried seemed to work either. 

Adding depends on IPV6 || IPV6=n doesn't work for SCSI_BNX2X_FCOE, but
works for SCSI_BNX2_ISCSI?

