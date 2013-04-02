Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3DBSIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760602Ab3DBSIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:08:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130329001048.GK5995@xanatos>
References: <20130329001048.GK5995@xanatos> <20130328201505.GC5995@xanatos> <20130328184827.29679.62426.stgit@warthog.procyon.org.uk> <20130328184835.29679.62285.stgit@warthog.procyon.org.uk> <32349.1364509973@warthog.procyon.org.uk>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the former is used in a.out.h
Date: Tue, 02 Apr 2013 19:07:36 +0100
Message-ID: <20541.1364926056@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> I guess my question is a deeper one: do we need to rename all the xHCI
> macros to have the XHCI_ prefix, in order to avoid future collision?
> For example, one of the macros is MAX_HC_PORTS, which could possibly be
> used by other host drivers in the future.

Hmmm...

I suspect the question is whether your symbols are likely to collide with
core symbols rather than symbols of unrelated drivers - after all, you're
unlikely to be #including the headers of those drivers.

I personally prefer to prefix the names of symbols in drivers with something
consistent for that driver to reduce namespace collisions - but I know not
everyone cares about that.  Linux doesn't have much of a policy in this area
though.  I also like it because it makes tags easier to use (fewer definitions
of the same symbol).

Whether you should go back and rename existing xHCI functions, I don't know.
I'd be tempted to leave it for now unless there's some collision.  However,
things like MAX_HC_PORTS does seem a little generic.  Further #define
collisions go unnoticed under some circumstances.  Two obvious cases are (a)
redefinition of a symbol because it happens to be the same value and (b) where
the second one is accidentally suppressed because it is wrapped in a
conditional.

Perhaps we should move to C++ and use namespaces;-)

David
