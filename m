Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3HTODe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:03:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:53651 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3HTODc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,920,1367996400"; 
   d="scan'208";a="389127227"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH next] netlink: prevent deadlock in ctrl_dumpfamily()
Thread-Topic: [PATCH next] netlink: prevent deadlock in ctrl_dumpfamily()
Thread-Index: AQHOnayPOuYC64fpwUidqxHggbfLn5meIIiQ
Date: Tue, 20 Aug 2013 14:03:25 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AA6F1BC@IRSMSX102.ger.corp.intel.com>
References: <20130820135033.GA2315@swordfish.minsk.epam.com>
In-Reply-To: <20130820135033.GA2315@swordfish.minsk.epam.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> +	if (need_locking) {
> +		/* genl_mutex could be already locked in genl_rcv_msg() */
> +		rt = genl_family_find_byid(cb->nlh->nlmsg_type);
> +		need_locking = need_locking && rt->parallel_ops;
> +	}

This is equivalent to reverting the patch because parallel_ops will be false for the genl family. :-)

johannes
-- 

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

