Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaDRDNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:13:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:2880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaDRDNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="522611660"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: RE: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Thread-Topic: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Thread-Index: AQHPWrAcRbIEWi18XUqckj4NN5SyAZsWsYLg
Date: Fri, 18 Apr 2014 03:13:04 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802554C0C@SHSMSX101.ccr.corp.intel.com>
References: <261e2207fab4a185b44fb27dbf9bc68588aea713.1397785844.git.lv.zheng@intel.com>
 <20140418024426.GA10084@kroah.com>
In-Reply-To: <20140418024426.GA10084@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, April 18, 2014 10:44 AM
> 
> On Fri, Apr 18, 2014 at 09:53:19AM +0800, Lv Zheng wrote:
> > Note that this patch is only used for stable kernels, upstream kernels
> > will have this problem fixed in ACPICA 201303-04 release.  So upstream
> > kernels shouldn't merge this commit.
> 
> What kernel commit fixed this issue in "upstream"?
> 
> > It is reported that there are buggy BIOSes in the world: AMI uses a XSDt
> > compiler for early BIOSes, this compiler will generate XSDT with a NULL
> > entry.  The affected BIOS versions are "AMI BIOS F2-F4".
> >
> > Original solution on Linux is to use an alternative heathy root table
> > instead of the ill one.  This commit is refined by the following ACPICA
> > commit that tries to reduce the source code differences between Linux and
> > ACPICA upstream.
> >   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
> >   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> > But according to the bug report, the XSDT in fact is not broken, we should
> > just add NULL entry sanity check before installing a table address from
> > XSDT.
> >
> > With the NULL entry sanity check implemented, the XSDT validation is
> > useless because:
> > 1. If XSDT contains NULL entries, it can be bypassed by the new sanity
> >    check mechanism;
> > 2. If RSDP contains a bad XSDT address, invoking XSDT validation will still
> >    lead to kernel crash.
> >
> > This patch deletes XSDT validation logics and adds code to skip NULL
> > entries that can be found in RSDT or XSDT. Lv Zheng.
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> > Buglink: https://bugs.archlinux.org/task/39811
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> > Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> > Cc: Zhao Yakui <yakui.zhao@intel.com>
> > Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
> 
> So this fix is only needed for 3.14?  Or older?  I'm confused here...

Only 3.14.1 - 3.15.1 kernels are affected.  Others are fine.
Possibly this urgent commit is useful for the users currently running 3.14 on such broken platforms.
I haven't obtained Rafael's ACKs on this.  We may discuss it in next week.

Thanks and best regards
-Lv

> greg k-h
