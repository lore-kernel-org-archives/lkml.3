Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaGHWaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:30:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaGHWaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:30:06 -0400
Date: Tue, 8 Jul 2014 15:34:25 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Message-ID: <20140708223425.GB6310@kroah.com>
References: <1403818501-15547-1-git-send-email-decui@microsoft.com>
 <20140708092709.GI25880@mwanda>
 <EE124450C0AAF944A40DD71E61F878C987A663@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C987A663@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:17:48PM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Tuesday, July 8, 2014 17:27 PM
> > To: Dexuan Cui
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> > devel@linuxdriverproject.org; plagnioj@jcrosoft.com;
> > tomi.valkeinen@ti.com; linux-fbdev@vger.kernel.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com; Haiyang Zhang
> > Subject: Re: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
> > force on VM panic
> > 
> > Don't use likely/unlikely unless you have benchmark numbers to show that
> > it makes a speed up.
> > 
> > regards,
> > dan carpenter
> 
> Hi Dan,
> Here the variable 'synchronous_fb' is only set to true when the system panics.
> So before the system panics, it's always 'unlikely'. :-)

Then take advantage of gcc's and your processor's prediction, which
knows that 0 is the "common" case and will choose to do the right thing
here.

Dan is right, never put those markings in your code unless you can
benchmark the difference.  Which means in reality, never put them in
your code.

thanks,

gerg k-h
