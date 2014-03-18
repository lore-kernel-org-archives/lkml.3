Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaCRBaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:30:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:47402 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaCRBaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:30:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500816970"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
Thread-Topic: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
Thread-Index: AQHPQdnB7zYfPwO/T0q0D+Kd5BOXuZrl/Opg//+HvgCAAIYqQA==
Date: Tue, 18 Mar 2014 01:29:55 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024E1BA1@SHSMSX101.ccr.corp.intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu>
 <5326E5E8.4070804@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024E1AE0@SHSMSX101.ccr.corp.intel.com>
 <2040389.QPkIWC2M7W@vostro.rjw.lan>
In-Reply-To: <2040389.QPkIWC2M7W@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2I1UL6c001809

Hi,

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Tuesday, March 18, 2014 9:13 AM
> 
> On Tuesday, March 18, 2014 12:31:54 AM Zheng, Lv wrote:
> > Hi, Rafael
> >
> > > From: Wysocki, Rafael J
> > > Sent: Monday, March 17, 2014 8:09 PM
> > >
> > > On 3/17/2014 5:14 AM, Lv Zheng wrote:
> > > > This feature enabled by the following commit is still under development.
> > > >
> > > >    Commit: cd52379678785b02d7a357988cfba214fdaf92f4
> > > >    Subject: ACPICA: Add global option to disable method auto-serialization.
> > > >    This change adds an option to disable the auto-serialization of
> > > >    methods that create named objects.
> > > >
> > > > This patch disables it by default temporarily according to the bug reports.
> > >
> > > Well, it doesn't restore the 3.14 behavior of acpi_auto_serialize, as
> > > far as I can say, so we can't apply it.
> > >
> > > I still can drop the commits related to auto-serialization from my
> > > acpica branch.  Which commits are they?
> >
> > From linux-pm/bleeding-edge branch, I found this series includes the following commits:
> >
> > Commit: a0fd108f2da56b769472fc0095616fb370988516
> > Author: Lv Zheng <lv.zheng@intel.com>
> > Subject: ACPI: Rename kernel parameter "acpi_serialize" to "acpi_no_auto_serialize"
> >
> > Commit: 5f1cb4a92e4c4aabd139ff9ca1e11c0e2db2ac59
> > Author: Lv Zheng <lv.zheng@intel.com>
> > Subject: ACPICA: Remove global option to serialize all control methods.
> >
> > Commit: cd52379678785b02d7a357988cfba214fdaf92f4
> > Author: Bob Moore <robert.moore@intel.com>
> > Subject: ACPICA: Add global option to disable method auto-serialization.
> >
> > Commit: f56b05bd111b01141ef74568dc4d262c70295d03
> > Author: Lv Zheng <lv.zheng@intel.com>
> > Subject: ACPICA: Add additional named objects for the auto-serialize method scan.
> >
> > Commit: 27f1899350a1d6baab117c03c87f0e37730047bd
> > Author: Bob Moore <robert.moore@intel.com>
> > Subject: ACPICA: Add auto-serialization support for ill-behaved control methods.
> >
> > Reverting these commits can restore original Linux behavior.
> > Please check.
> 
> OK, I dropped the five commits above from the acpica branch.
> 
> Please check if the current ACPICA material in the bleeding-edge branch of
> linux-pm.git looks OK (and let me know either way).

It took me some time to confirm.
I just checked ACPICA code using the ACPICA divergence script.
And checked the Linux side reversal in osl.c/kernel-parameter.txt.
All seem to be OK.

Best regards
-Lv

> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
