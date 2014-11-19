Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaKSCFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:05:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaKSCFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:05:03 -0500
Date: Tue, 18 Nov 2014 18:05:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Ming Lei <ming.lei@canonical.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Message-ID: <20141119020502.GC6054@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
 <20141108190655.GA2638@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8529E3@PGSMSX102.gar.corp.intel.com>
 <20141117151211.GB6810@console-pimps.org>
 <F54AEECA5E2B9541821D670476DAE19C2B85DA57@PGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B85DA57@PGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 06:31:38AM +0000, Kweh, Hock Leong wrote:
> > -----Original Message-----
> > From: Matt Fleming [mailto:matt@console-pimps.org]
> > Sent: Monday, November 17, 2014 11:12 PM
> > >
> > > - Only doing module unload is required to be aware of this synchronization
> > > 	-> Ensuring the call back does not fall into unloaded code which may
> > cause
> > > 	     undefined behavior.
> > > 	-> Ensuring the put_device() & module_put() code have finished in
> > firmware_class.c
> > > 	     function request_firmware_work_func() before the device is
> > unregistered
> > > 	     and module unloaded happen.
> > 
> > Shouldn't the existing module_{put,get}() and {put,get}_device() calls
> > provide all the necessary synchronisation?
> > 
> > Module unload should not be possible while other code is using the
> > module (and the module refcnt has been incremented accordindly).
> > 
> > Right?
> > 
> > --
> > Matt Fleming, Intel Open Source Technology Center
> 
> Hi Matt,
> 
> Yes, you are right. If the module refcount is not zero, you will get error
> message and returned while you do "rmmod". But I strongly believe if we
> have the capability in our code to take care of it by doing synchronization,
> we should take care of it in case people are doing "rmmod -f". Don't
> you think so?

If you do 'rmmod -f' you get to keep all of the broken pieces of your
kernel, no need to try to help out with crazy things like that.

greg k-h
