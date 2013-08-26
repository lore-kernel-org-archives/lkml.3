Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3HZXLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 19:11:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3HZXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 19:11:13 -0400
Date: Mon, 26 Aug 2013 16:13:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
 channel offers
Message-ID: <20130826231330.GB26285@kroah.com>
References: <1377551338-29582-1-git-send-email-kys@microsoft.com>
 <20130826215656.GA2276@kroah.com>
 <240d7113f9cd4862a44bd5d6a7751ca0@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <240d7113f9cd4862a44bd5d6a7751ca0@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:48:16PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Monday, August 26, 2013 2:57 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com; stable@vger.kernel.org
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of channel
> > offers
> > 
> > On Mon, Aug 26, 2013 at 02:08:58PM -0700, K. Y. Srinivasan wrote:
> > > The channel state should be correctly set before registering the device. In the
> > current
> > > code the driver probe would fail for channels that have been rescinded and
> > subsequently
> > > re-offered. Fix the bug.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Cc: <stable@vger.kernel.org>
> > 
> > What older kernel versions have this bug?  When did it show up?
> 
> The patch that introduced the bug is:
> 
> commit e68d2971d26577b932a16333ce165af98a96e068
> Author: K. Y. Srinivasan <kys@microsoft.com>
> Date:   Thu May 23 12:02:32 2013 -0700
> 
>     Drivers: hv: vmbus: Implement multi-channel support
> 
> I think 3.10 shipped with this bug.

Why do you think that, it's not what git shows:
	$ git describe --contains e68d2971d26577b932a16333ce165af98a96e068
	v3.11-rc1~157^2~64

So this is a 3.11-only thing, right?

thanks,

greg k-h
