Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3ICP7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:59:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:5926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab3ICP7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:59:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1014,1367996400"; 
   d="scan'208";a="397582563"
Date: Tue, 3 Sep 2013 08:58:57 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: kumargauravgupta3@gmail.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v4:No,Change] xHCI:Fixing xhci_readl definition and function
 call
Message-ID: <20130903155857.GA2657@xanatos>
References: <5223383f.hCMXrpqEq1AlVw9b%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5223383f.hCMXrpqEq1AlVw9b%wangshilong1991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 08:51:11PM +0800, Wang Shilong wrote:
> Hello, Using checkpatch.pl, i get the following warnings(errors):
> WARNING: Avoid CamelCase: <port_array[wIndex]>
> #272: FILE: drivers/usb/host/xhci-hub.c:725:
> +		temp = xhci_readl(port_array[wIndex]);
> 
> total: 0 errors, 1 warnings, 826 lines checked
> 
> patch has style problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.

Ignore this warning.  The variable is called wIndex because it
corresponds to a field in a USB control transfer, and that's what it's
called in the spec.  In this case, wIndex is the index into the hub's
port array, so it's perfectly valid to use it as an array index here.

In general, if checkpatch.pl complains about a variable a patch
introduces that's CamelCase, you should pay attention to it.  If it's a
variable that already present in USB code, it's probably used to match
the spec.

Sarah Sharp
