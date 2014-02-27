Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaB0Xj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:39:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:24442 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaB0Xj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:39:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,558,1389772800"; 
   d="scan'208";a="414400857"
Date: Thu, 27 Feb 2014 15:45:24 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@intel.com,
        jin.can.zhuang@intel.com, yu.y.wang@intel.com
Subject: Re: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
Message-ID: <20140227234523.GB21032@psi-dev26.jf.intel.com>
References: <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
 <xa1teh2o4uqq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xa1teh2o4uqq.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:15:25PM +0100, Michal Nazarewicz wrote:
> On Thu, Feb 27 2014, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
> > When the request length is aligned to maxpacketsize, sometimes
> > the return length ret > the user space requested len.
> >
> > At that time, we will use min_t(size_t, ret, len) to limit the
> > size in case of user data buffer overflow.
> >
> > But we need return the min_t(size_t, ret, len) to tell the user
> > space rightly also.
> >
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>

IMHO it makes sense to push this patch to 3.14-rc since it is an
extension of usb gadget's quick_ep_out_aligned_size merged on 3.14-rc1

Br, David Cohen
