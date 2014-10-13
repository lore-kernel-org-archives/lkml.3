Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaJMQz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:55:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:37742 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbaJMQzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:55:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="399518302"
Date: Mon, 13 Oct 2014 09:55:56 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, mina86@mina86.com, r.baldyga@samsung.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH v2] usb: ffs: fix regression when
 quirk_ep_out_aligned_size flag is set
Message-ID: <20141013165556.GA4034@psi-dev26.jf.intel.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013153212.GE21709@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013153212.GE21709@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 10:32:12AM -0500, Felipe Balbi wrote:
> On Wed, Oct 08, 2014 at 02:12:18PM -0700, David Cohen wrote:
> > The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> > quirk implemented to align buffer size to maxpacketsize on out endpoint.
> > As result, functionfs does not work on Intel platforms using dwc3 driver
> > (i.e. Bay Trail and Merrifield). This patch fixes the issue.
> > 
> > This code is based on a previous Qiuxu's patch.
> > 
> > Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
> > Cc: <stable@vger.kernel.org> # v3.16+
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> > ---
> > 
> > Hi,
> > 
> > Since this is a feature that worked in past, this is meant for stable
> > versions >= 3.16 too.
> > 
> > v1 to v2: just added Fixes, Cc and Acked-by lines on patch description.
> 
> this adds a build warning for use of maybe unitialized data_len. Plese
> fix.

It's a false-positive warning. data_len is only initialized if halt != 0
and it's only used if halt != 0 too.

Do you prefer to initialize it to 0 during the declaration to silent the
compiler?

BR, David

> 
> -- 
> balbi


