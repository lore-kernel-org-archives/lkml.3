Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264Ab3DBThT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:37:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:17053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3DBThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="311336735"
Date: Tue, 2 Apr 2013 12:37:15 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the
 former is used in a.out.h
Message-ID: <20130402193715.GA3693@xanatos>
References: <20130329001048.GK5995@xanatos>
 <20130328201505.GC5995@xanatos>
 <20130328184827.29679.62426.stgit@warthog.procyon.org.uk>
 <20130328184835.29679.62285.stgit@warthog.procyon.org.uk>
 <32349.1364509973@warthog.procyon.org.uk>
 <20541.1364926056@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20541.1364926056@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:07:36PM +0100, David Howells wrote:
> Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> 
> > I guess my question is a deeper one: do we need to rename all the xHCI
> > macros to have the XHCI_ prefix, in order to avoid future collision?
> > For example, one of the macros is MAX_HC_PORTS, which could possibly be
> > used by other host drivers in the future.
> 
> Hmmm...
> 
> I suspect the question is whether your symbols are likely to collide with
> core symbols rather than symbols of unrelated drivers - after all, you're
> unlikely to be #including the headers of those drivers.
> 
> I personally prefer to prefix the names of symbols in drivers with something
> consistent for that driver to reduce namespace collisions - but I know not
> everyone cares about that.  Linux doesn't have much of a policy in this area
> though.  I also like it because it makes tags easier to use (fewer definitions
> of the same symbol).
> 
> Whether you should go back and rename existing xHCI functions, I don't know.
> I'd be tempted to leave it for now unless there's some collision.  However,
> things like MAX_HC_PORTS does seem a little generic.  Further #define
> collisions go unnoticed under some circumstances.  Two obvious cases are (a)
> redefinition of a symbol because it happens to be the same value and (b) where
> the second one is accidentally suppressed because it is wrapped in a
> conditional.

Hmm, yeah, I think it doesn't make sense to change all the macros now.
If I were starting a new driver, I think I would use a common prefix.
I'll add the macro renaming to my todo list and see if I can get some
newbie to take it on. 8)

> Perhaps we should move to C++ and use namespaces;-)

Hah!

Sarah Sharp
