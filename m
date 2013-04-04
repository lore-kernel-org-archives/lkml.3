Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012Ab3DDPn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:43:57 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:36537 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761488Ab3DDPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:43:56 -0400
Date: Thu, 4 Apr 2013 08:43:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Christopher Li <sparse@chrisli.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel/workqueue.c:4434:61: sparse: expression using sizeof bool
Message-ID: <20130404154351.GM9425@htj.dyndns.org>
References: <5156dabb.76yJdh7eK0MDrdWo%fengguang.wu@intel.com>
 <20130403215718.GH3411@htj.dyndns.org>
 <20130404014209.GB7328@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404014209.GB7328@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Apr 04, 2013 at 09:42:09AM +0800, Fengguang Wu wrote:
> > >   4433		/* copy worker description */
> > > > 4434		probe_kernel_read(&desc_valid, &worker->desc_valid, sizeof(desc_valid));
> > >   4435		if (desc_valid)
> > 
> > I don't know what to make of this warning.  Yes, it's probing a bool
> > variable and of course using sizeof(bool) to do that.  Why does sparse
> > complain about this?
> 
> I guess sparse warns on sizeof(bool) because it is compiler defined.
> It may be 1, 4, or even 8 depending on the gcc version and platform.

Yeah, it's copying out a bool so as long as that's the actual size,
it's okay.  I mean, it's not like sizeof(long) is constant across
platforms.  I'm gonna ignore it but still curious what the warning is
good for.

Thanks.

-- 
tejun
