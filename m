Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaKQWHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:07:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbaKQWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:07:22 -0500
Date: Mon, 17 Nov 2014 17:07:06 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Antonio Borneo <borneo.antonio@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: fix race condition reading reports
Message-ID: <20141117220706.GD30324@mail.corp.redhat.com>
References: <1416149064-25655-1-git-send-email-borneo.antonio@gmail.com>
 <20141117214305.GC30324@mail.corp.redhat.com>
 <20141117215111.GA19828@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141117215111.GA19828@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17 2014 or thereabouts, Greg KH wrote:
> On Mon, Nov 17, 2014 at 04:43:05PM -0500, Benjamin Tissoires wrote:
> > Hey Antonio,
> > 
> > On Nov 16 2014 or thereabouts, Antonio Borneo wrote:
> > > From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> > > 
> > > From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> > > 
> > > Current driver uses a common buffer for reading reports either
> > > synchronously in i2c_hid_get_raw_report() and asynchronously in
> > > the interrupt handler.
> > > There is race condition if an interrupt arrives immediately after
> > > the report is received in i2c_hid_get_raw_report(); the common
> > > buffer is modified by the interrupt handler with the new report
> > > and then i2c_hid_get_raw_report() proceed using wrong data.
> > > 
> > > Fix it by using a separate buffers for asynchronous reports.
> > > 
> > > Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> > > [Antonio Borneo: cleanup and rebase to v3.17]
> > > Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> > > Cc: stable@vger.kernel.org
> > 
> > For your next submission, when you want a patch to go in stable, put CC
> > here, but please do not CC the actual mail to stable@. Stable should receive
> > either mails which are already in Linus' tree, or which refer a commit
> > in Linus' tree in case it does not applies smoothly.
> > 
> > [keeping stable@ here to show them that this one should not get picked
> > right now]
> 
> stable@ is smarter than that, I don't mind seeing patches that are
> coming in the future like this at all, it's not a problem.
> 

OK. Sorry for the noise then. I assumed that if everybody starts sending
potential patches to stable without them being the accepted ones, you
will end up having to deal with a lot more workload that you already have.

And just to be sure that there is no misinterpretation, I did not wanted
to imply that stable was not smart enough to deal with such patches... I
really appreciate the work done and my concern was to not add workload.

Cheers,
Benjamin

> thanks,
> 
> greg k-h
