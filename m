Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab3ANWl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:41:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:8573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab3ANWl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,468,1355126400"; 
   d="scan'208";a="243758269"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "rob@landley.net" <rob@landley.net>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "lliubbo@gmail.com" <lliubbo@gmail.com>,
        "jaegeuk.hanse@gmail.com" <jaegeuk.hanse@gmail.com>,
        "glommer@parallels.com" <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Index: AQHN8jfezP7hxPPawkaXDMerNaAcgJhJm6qAgABUxAD//3o84A==
Date: Mon, 14 Jan 2013 22:41:03 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
	<50F440F5.3030006@zytor.com>
 <20130114143456.3962f3bd.akpm@linux-foundation.org>
In-Reply-To: <20130114143456.3962f3bd.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, why.  Obviously SRAT support will improve things, but is it
> actually unusable/unuseful with the command line configuration?

Users will want to set these moveable zones along node boundaries
(the whole purpose is to be able to remove a node by making sure
the kernel won't allocate anything tricky in it, right?)  So raw addresses
are usable ... but to get them right the user will have to go parse the
SRAT table manually to come up with the addresses. Any time you
make the user go off and do some tedious calculation that the computer
should have done for them is user-abuse.

-Tony 
