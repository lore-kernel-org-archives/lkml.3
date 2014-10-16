Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaJPSZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:25:42 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:58209 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJPSZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:25:40 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Thread-Topic: [PATCH v2 2/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Thread-Index: AQHP6RSa8bCahxz6RUSMhZSlN5pmz5wzK36AgAAZNQD//8QBAA==
Date: Thu, 16 Oct 2014 18:25:35 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E2A38@US01WEMBX2.internal.synopsys.com>
References: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413445270-27672-2-git-send-email-sudipm.mukherjee@gmail.com>
 <20141016132155.GC3480@saruman> <20141016145208.GA8358@sudip-PC>
In-Reply-To: <20141016145208.GA8358@sudip-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> Sent: Thursday, October 16, 2014 7:52 AM
> 
> On Thu, Oct 16, 2014 at 08:21:55AM -0500, Felipe Balbi wrote:
> > HI,
> >
> > On Thu, Oct 16, 2014 at 01:11:10PM +0530, Sudip Mukherjee wrote:
> > > sparse was giving the following warning:
> > >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > > 	        - different lock contexts for basic block
> > >
> > > we were returning ENOMEM while still holding the spinlock.
> > > The sparse warning was fixed by releasing the spinlock before return.
> > >
> > > This patch depends on the previous patch of the series.
> > >
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> >
> > this should be patch one so it can be backported to stable kernels.
> >
> my v1 patch fixed only this , while reviewing that one Paul Zimmerman suggested to rewrite the return
> statements.
> so this v2 series had the rewrite and the spinlock error fix.
> now if this is to be made the patch one then it will be a duplicate of my v1 followed by another patch
> for return statements.
> should i do that ?

Hi Sudip,

Please make the first patch like I showed in my previous reply. Then we
can mark that one for stable to fix the bug. Then make a second patch to
change the other error path.

-- 
Paul

