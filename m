Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbaAJUnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:43:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAJUnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:43:22 -0500
Date: Fri, 10 Jan 2014 12:43:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Intel MIC host driver: possible signed underflow (undefined
 behavior) in userspace API
Message-ID: <20140110204354.GD10235@kroah.com>
References: <1151498255.5788.1389332631491.JavaMail.zimbra@efficios.com>
 <1593870977.5807.1389333385962.JavaMail.zimbra@efficios.com>
 <20140110142116.GB7212@kroah.com>
 <1389378175.83628.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389378175.83628.14.camel@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:22:55AM -0800, Sudeep Dutt wrote:
> On Fri, 2014-01-10 at 06:21 -0800, Greg Kroah-Hartman wrote:
> > On Fri, Jan 10, 2014 at 05:56:25AM +0000, Mathieu Desnoyers wrote:
> > > Hi,
> > > 
> > > Looking at this commit:
> > > 
> > > commit f69bcbf3b4c4b333dcd7a48eaf868bf0c88edab5
> > > Author: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > > Date:   Thu Sep 5 16:42:18 2013 -0700
> > > 
> > >     Intel MIC Host Driver Changes for Virtio Devices.
> > > 
> > > Especially at:
> > > 
> > > +struct mic_copy_desc {
> > > +#ifdef __KERNEL__
> > > +       struct iovec __user *iov;
> > > +#else
> > > +       struct iovec *iov;
> > > +#endif
> > > +       int iovcnt;
> > > +       __u8 vr_idx;
> > > +       __u8 update_used;
> > > +       __u32 out_len;
> > > +};

Oh, there's also the obvious 32/64 bit userspace/kernel issue here as
well, but I'm sure you all know how to handle that properly.  It would
be nice to fix that up, if you can change the ABI still.

thanks,

greg k-h
