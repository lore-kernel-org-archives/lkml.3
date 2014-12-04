Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaLDRqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:46:48 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43992 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbaLDRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:46:46 -0500
Date: Thu, 4 Dec 2014 09:46:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: Dudley Du <dudley.dulixin@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
 firmware image function support
Message-ID: <20141204174641.GB4806@dtor-ws>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
 <1415003590-30485-16-git-send-email-dudl@cypress.com>
 <20141110083955.GD39688@dtor-ws>
 <ad3bf85500174b25a4dc8f796d10d0a3@BN1PR06MB070.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad3bf85500174b25a4dc8f796d10d0a3@BN1PR06MB070.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:05:39AM +0000, Dudley Du wrote:
> Thanks, Dmitry
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: 2014?11?10? 16:40
> > To: Dudley Du
> > Cc: rydberg@euromail.se; Dudley Du; bleung@google.com;
> > linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v9 15/18] input: cyapa: add gen3 trackpad device read
> > firmware image function support
> >
> > On Mon, Nov 03, 2014 at 04:33:07PM +0800, Dudley Du wrote:
> > > Add read firmware image function supported for gen3 trackpad device,
> > > it can be used through debugfs read_fw interface.
> >
> > Why do we need this? Can we do the same via usespace program accessing
> > the i2c device through /dev/i2c-N?
> 
> This interface is used to test and debug only. It's defined and required by the chromium projects.
> 
> And in the driver side, becase the firmware image read process is done based on interrupt signal,
> if do this in userspace through /dev/i2c-N, there will be two issues:
> 1) for gen5, after each command, an interrupt will be asserted, so if throug /dev/i2c-N,
> userspace program cannot get the interrupt signal.
> 2) and when the interrupt signal assert, driver won't know it’s a command signal for image read,
> so it will try to process it as data report.
> To avoid this, additional interface must be added to mark the image read status and
> block interrupt signal to be process as data report.

I believe that while userspace acc4esses the device through /dev/i2c-N
you should unbind the cyapa driver from the device (via sysfs driver
core bind/unbind attribute) so that it doe snot get in the way. Once
diagnostics is done you can bind the driver back to device, restoring
normal operation.

That is how we are planning to handle other devices at factory as
well.

Thanks.

-- 
Dmitry
