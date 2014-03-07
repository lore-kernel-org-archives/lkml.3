Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaCGVIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:08:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaCGVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:08:48 -0500
Date: Fri, 7 Mar 2014 13:08:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20140307130846.ad8ee2b20c6f2dcf6d0b6a33@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1403071103040.21846@nuc>
References: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au>
	<20140306134848.7aabdc426fbad30f6e818631@linux-foundation.org>
	<20140307115744.5c3d5475af77726dc6c5a76b@canb.auug.org.au>
	<20140306173822.1f4fed3a.akpm@linux-foundation.org>
	<alpine.DEB.2.10.1403071103040.21846@nuc>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014 11:05:49 -0600 (CST) Christoph Lameter <cl@linux.com> wrote:

> On Thu, 6 Mar 2014, Andrew Morton wrote:
> 
> > > So, by "the whole series" do you mean just/all these:
> > >
> > > percpu-add-raw_cpu_ops.patch
> > > ...
> > > sh-replace-__get_cpu_var-uses.patch
> >
> > Yep.  Commented out in http://ozlabs.org/~akpm/mmots/series
> >
> > > If so, I will remove them from my tree today (if you don't get around to
> > > a new mmotm before then).
> >
> > Cool.
> 
> I need at least the initial 5 patches that establish the framework in
> -next and do the debugging in order to make further progress on this one.

I'll re-enable

percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch

OK?

> The rest are bits and pieces that may require some detail work.

It looks like they will need quite a lot of work I'm afraid.  The
automated sweep wasn't very successful but it did demonstrate that
there are nasties and gremlins all over the place.


