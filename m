Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaDRDjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:39:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaDRDjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:39:41 -0400
Date: Thu, 17 Apr 2014 20:39:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Message-ID: <20140418033945.GA20137@kroah.com>
References: <261e2207fab4a185b44fb27dbf9bc68588aea713.1397785844.git.lv.zheng@intel.com>
 <20140418024426.GA10084@kroah.com>
 <1AE640813FDE7649BE1B193DEA596E8802554BEC@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802554BEC@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 03:00:21AM +0000, Zheng, Lv wrote:
> Hi, Greg
> 
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, April 18, 2014 10:44 AM
> > 
> > On Fri, Apr 18, 2014 at 09:53:19AM +0800, Lv Zheng wrote:
> > > Note that this patch is only used for stable kernels, upstream kernels
> > > will have this problem fixed in ACPICA 201303-04 release.  So upstream
> > > kernels shouldn't merge this commit.
> > 
> > What kernel commit fixed this issue in "upstream"?
> 
> There is no kernel commit now has fixed this issue in "upstream".
> The fix commit need to go into ACPICA first, so I believe it will
> appear in 3.15-rc2 (ACPICA 201403xx release) or 3.15-rc3 (ACPICA
> 201404xx release).

Then I can't take this patch at all in any stable tree.  Please read
Documentation/stable_kernel_rules.txt for why and how to properly do
this.

Just mark the commit that fixes the issue in Linus's tree for stable,
and it will happen automatically.

> The back port of the fix commit will have many dependencies as we have
> a big change in ACPICA table manager in ACPICA 201403xx release.

Why not just submit this fix first to Linus, for his tree now, and then
do the larger changes later?

> However this back port is very light and has been confirmed by the reporters.
> 
> The bug seems to be urgent, it has broken many platforms shipped with
> AMI BIOSes versioning from F2 to F4.  Someone may monitor here to find
> a valid fix.

Not any stable maintainers, we can't take patches that aren't in Linus's
tree, sorry.

greg k-h
