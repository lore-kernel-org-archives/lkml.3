Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaLHV6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:58:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:9046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbaLHV6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:58:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="650530885"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH] ACPI, EINJ: Enhance error injection tolerance level
Thread-Topic: [PATCH] ACPI, EINJ: Enhance error injection tolerance level
Thread-Index: AQHQErYBvJljPJCVjkWnDEnz5isqXZyGO4+g
Date: Mon, 8 Dec 2014 21:58:33 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32961DDF@ORSMSX114.amr.corp.intel.com>
References: <c5f50564109273ab7f1c5fab4490169ae573128d.1417641347.git.tony.luck@intel.com>
 <54854EAC.8090504@linaro.org>
In-Reply-To: <54854EAC.8090504@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it solves problem related to ACPI, you should not use in this file:
> > +	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
> > +		return 0;
> This is very x86 specific. We are making a lot of effort to make 
> MMCONFIG platform independent now.

So you'd like to see the changes in this patch spread out across more
appropriate files?  pci_mmcfg_for_each_region() moving off into
arch/x86/pci/mmconfig-shared.c, for example.

I'm not sure how to make that pretty in apei_resources_request()
where essentially we need to add an extra scan for some arch
specific addresses to ignore from the list of addresses.

-Tony
