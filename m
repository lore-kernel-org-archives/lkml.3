Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaA3WkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:40:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:38098 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbaA3Wj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:39:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,752,1384329600"; 
   d="scan'208";a="475465157"
Date: Thu, 30 Jan 2014 14:39:47 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv2 00/10] xhci: re-work command queue management
Message-ID: <20140130223947.GE14228@xanatos>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 02:25:48PM +0000, David Laight wrote:
> I think it would be much simpler to allocate a parallel array to the actual
> hardware command ring that contains the additional information for the request
> (instead of allocating it pre-request).
> This would immediately solve any problems allocating the memory from interrupt
> context and failing to free in correctly in all the code paths.
> 
> A similar solution could be used for the transfer rings thus removing the
> need to the 'td' list - which there are reports of it failing to find transfers
> and the code paths for aborting isoch transfers are badly broken.
> 
> Adding another list that will have its own set of bugs seems retrograde top me.

I do not have a problem with it.  The shadow ring is an optimization we
can look at later.

Sarah Sharp
