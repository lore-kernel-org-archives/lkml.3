Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183Ab3DBQtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:49:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:60760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab3DBQtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:49:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="311267525"
From: "Luck, Tony" <tony.luck@intel.com>
To: Yijing Wang <wangyijing@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [PATCH 2/2] PCI/IA64: fix pci_dev->enable_cnt balance when
 doing pci hotplug
Thread-Topic: [PATCH 2/2] PCI/IA64: fix pci_dev->enable_cnt balance when
 doing pci hotplug
Thread-Index: AQHOLrUMFFEjeq7TGE6qhHVop7NyBpjB8KlQgADCqwCAAHF7QA==
Date: Tue, 2 Apr 2013 16:49:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E096762@ORSMSX108.amr.corp.intel.com>
References: <1364805775-12396-1-git-send-email-wangyijing@huawei.com>
 <1364805775-12396-2-git-send-email-wangyijing@huawei.com>
 <3908561D78D1C84285E8C5FCA982C28F1E096033@ORSMSX108.amr.corp.intel.com>
 <515A48E8.60605@huawei.com>
In-Reply-To: <515A48E8.60605@huawei.com>
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

> But this patch mainly to fix the unbalanced dev->enable_cnt in IA64 which will print WARNING Calltrace
> in dmesg.
Thanks for the explanation.

> If you think it is valuable, I will try to improve resource assignment in IA64 like other arch (eg arm, m68k, mips and sh..)
> in another patch.

Making the ia64 code more like the x86 code might help avoid such problems in the future (lots
more people look at x86 than ia64 - if ours is the same, or very similar, then it is likely that changes
made to x86 will be correct for ia64 too).

Only you can decide how much this is worth to you and your company - perhaps there will be no more
changes that break ia64 even with the code differences. Or perhaps it will be easier for you to just
fix things as they break than to undertake a restructure of the code.

-Tony
