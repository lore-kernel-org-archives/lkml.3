Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3C2AKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 20:10:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:17570 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab3C2AKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 20:10:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,369,1363158000"; 
   d="scan'208";a="308924766"
Date: Thu, 28 Mar 2013 17:10:48 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the
 former is used in a.out.h
Message-ID: <20130329001048.GK5995@xanatos>
References: <20130328201505.GC5995@xanatos>
 <20130328184827.29679.62426.stgit@warthog.procyon.org.uk>
 <20130328184835.29679.62285.stgit@warthog.procyon.org.uk>
 <32349.1364509973@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32349.1364509973@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 10:32:53PM +0000, David Howells wrote:
> Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> 
> > I'm a little bit confused about your description for the second one.
> > Did you need to change the #defines names because they could conflict
> > with other drivers when the xHCI driver is built in?  Or is there some
> > other point I'm missing?
> 
> Sorry, I should say.  I'm trying to clean up the UAPI headers and I noticed
> that the xHCI SEGMENT_SIZE macro is named the same as one defined by a.out.h
> that cannot be changed as it is seen by userspace.  Although it's unlikely
> that within the kernel they are unlikely to collide, one cannot be entirely
> sure that will stay true as new arches get added (hopefully no one will add
> new arches that use a.out format).  It seems best that the xHCI one be renamed
> if possible.

I guess my question is a deeper one: do we need to rename all the xHCI
macros to have the XHCI_ prefix, in order to avoid future collision?
For example, one of the macros is MAX_HC_PORTS, which could possibly be
used by other host drivers in the future.

Note that I'm not asking you to do this, just if it needs to be done.

Sarah Sharp
