Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3IMMdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:33:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3IMMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:33:51 -0400
Date: Fri, 13 Sep 2013 05:34:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
Message-ID: <20130913123405.GB29683@kroah.com>
References: <20130913005133.GA32479@localhost>
 <20130913031700.GB23757@kroah.com>
 <20130913033803.GB8704@localhost>
 <20130913034413.GA26166@kroah.com>
 <5232E123.9090909@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5232E123.9090909@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:55:47AM -0400, Peter Hurley wrote:
> On 09/12/2013 11:44 PM, Greg KH wrote:
> > On Fri, Sep 13, 2013 at 11:38:04AM +0800, Fengguang Wu wrote:
> >> On Thu, Sep 12, 2013 at 08:17:00PM -0700, Greg KH wrote:
> >>> On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
> >>>> Hi Peter,
> >>>>
> >>>> FYI, we noticed much increased vmap_area_lock contentions since this
> >>>> commit:
> >>>
> >>> What does that mean?  What is happening, are we allocating/removing more
> >>> memory now?
> 
> No. Same amount of memory, allocated and freed with the same frequency as
> before.

Ok, I thought so.

> >>> What type of load were you running that showed this problem?
> >>
> >> The increased contentions and lock hold/wait time showed up in a
> >> number of test cases.
> 
> [...]
> 
> > That's a lot of slowdowns, especially for such a simple patch.
> >
> > Peter, any ideas?
> 
> Looks like this patch incidentally triggers some worst-case behavior in
> the memory manager. I'm not sure how this is possible with two 4k buffers,
> but the evidence is substantial.
> 
> This patch isn't critical so I suggest we back out this patch for mainline
> but use the patch to find out what's wrong in the vmap area.
> 
> Unfortunately, I'm on my way out the door and won't be back til Sunday pm (EST)
> so I'll get a revert to you then. Sorry 'bout that.

No rush, we have plenty of time.

I think it would be good to track down the real root cause of this, so
that the allocators don't run into this problem again with some other
innocuous change.

thanks,

greg k-h

> 
> Regards,
> Peter Hurley
