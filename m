Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaJHRyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:54:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:55471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaJHRys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,679,1406617200"; 
   d="scan'208";a="615315218"
Date: Wed, 8 Oct 2014 10:53:52 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, mina86@mina86.com, r.baldyga@samsung.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size
 flag is set
Message-ID: <20141008175352.GB16791@psi-dev26.jf.intel.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141008003144.GA9957@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008003144.GA9957@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 07:31:44PM -0500, Felipe Balbi wrote:
> Hi,

Hi Felipe,

> 
> On Tue, Oct 07, 2014 at 05:18:06PM -0700, David Cohen wrote:
> > The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> 
> did that commit non-aio or is only aio broken ?

That commit broke the quirk on both cases.

> 
> > quirk implemented to align buffer size to maxpacketsize on out endpoint.
> > As result, functionfs does not work on Intel platforms using dwc3 driver
> > (i.e. Bay Trail and Merrifield). This patch fixes the issue.
> 
> and Braswell.
> 
> > This code is based on a previous Qiuxu's patch.
> 
> How have you tested this ? Do you have a test-case to share ? Then I can
> add it to my tests which I have been running on my platforms too (they
> include USB20CV and USB30CV where applicable - quite a few fixes coming
> soon).

My testcase is to use Android's adbd service via function_fs (no
out-of-tree android gadget). Without the quitk, it doesn't work.

Br, David

> 
> cheers
> 
> -- 
> balbi


