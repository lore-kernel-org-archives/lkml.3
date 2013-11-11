Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3KKNXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:23:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:46534 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3KKNX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:23:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,677,1378882800"; 
   d="scan'208";a="431308206"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Thomas Pedersen <thomas@cozybit.com>, Jouni Malinen <j@w1.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Holtmann, Marcel" <marcel.holtmann@intel.com>
Subject: RE: [init_mac80211_hwsim] BUG: unable to handle kernel paging
 request at cd1aa02c
Thread-Topic: [init_mac80211_hwsim] BUG: unable to handle kernel paging
 request at cd1aa02c
Thread-Index: AQHO27RexWzc/guFJkqY0KS9E3OYFZogCqmg
Date: Mon, 11 Nov 2013 13:23:25 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AAEC7D8@IRSMSX102.ger.corp.intel.com>
References: <20131107122443.GA11161@localhost>
In-Reply-To: <20131107122443.GA11161@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [    5.543416] ieee80211 phy0: Failed to select rate control algorithm
> [    5.543993] ieee80211 phy0: Failed to initialize rate control algorithm
> [    5.556937] mac80211_hwsim: ieee80211_register_hw failed (-2)
> [    5.557669] BUG: unable to handle kernel paging request at cd1aa02c
> [    5.558381] IP: [<c09bd01b>] kobject_get+0x2b/0xb0
> [    5.558922] *pdpt = 0000000002c20001 *pde = 000000000fbfc067 *pte =
> 800000000d1aa060

Yeah this is a known bug in hwsim - if registration fails (here apparently because you have no rate scaling) then it crashes - the error path is broken. Luckily, this never actually happens in practice. I'm supposed to get some patches from Marcel which I think will (have to) fix this.

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

