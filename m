Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3A1Rpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:45:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:18523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab3A1Rps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:45:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,553,1355126400"; 
   d="scan'208";a="283154136"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tang Chen <tangchen@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: RE: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
Thread-Topic: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
Thread-Index: AQHN+uB0hT0zOkmMI0W0/B8xsJDlF5hbVMcAgAAEzwCAAy8egIAAfmwA
Date: Mon, 28 Jan 2013 17:45:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C98F9CB@ORSMSX108.amr.corp.intel.com>
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com>
 <1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com>
 <20130125171230.34c5a273.akpm@linux-foundation.org>
 <51033186.3000706@zytor.com> <5105DD4B.9020901@cn.fujitsu.com>
In-Reply-To: <5105DD4B.9020901@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I will post a patch to fix it. How about always keep node0 unhotpluggable ?

Node 0 (or more specifically the node that contains memory <4GB) will be
full of BIOS reserved holes in the memory map. It probably isn't removable
even if Linux thinks it is.  Someday we might have a smart BIOS that can
relocate itself to another node - but for now making node0 unhotpluggable
looks to be a plausible interim move.

Ultimately we'd like to be able to remove any node (just not all of them at
the same time ... just like we can now offline any cpu - but not all of them
together).

-Tony
