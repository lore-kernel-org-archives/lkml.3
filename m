Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3AOIcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:32:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:9660 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab3AOIcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:32:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,471,1355126400"; 
   d="scan'208";a="243968391"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [sysfs_write_file] net/wireless/reg.c:144 suspicious
 rcu_dereference_protected() usage!
Thread-Topic: [sysfs_write_file] net/wireless/reg.c:144 suspicious
 rcu_dereference_protected() usage!
Thread-Index: AQHN8rk5bYQzo+Mmhkus6v2zCca1sJhKD9Zg
Date: Tue, 15 Jan 2013 08:31:16 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61960E1A7@IRSMSX102.ger.corp.intel.com>
References: <20130115004213.GB5512@localhost>
In-Reply-To: <20130115004213.GB5512@localhost>
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

> commit c492db370c17c428a0a58d3673294d4e99634b7d
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Dec 6 16:29:25 2012 +0100
> 
>     regulatory: use RCU to protect last_request
> 
>     This will allow making freq_reg_info() lock-free.
> 
>     Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> [   38.437215]
> [   38.437457] ===============================
> [   38.438047] [ INFO: suspicious RCU usage. ]
> [   38.438635] 3.8.0-rc1-00184-gfb97c3e #24 Not tainted

Yep, thanks. Already fixed by 4a484cffc5e1836114e9556f7c704412d491200c, I believe.

johannes
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

