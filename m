Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3C1Wc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab3C1Wc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:32:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130328201505.GC5995@xanatos>
References: <20130328201505.GC5995@xanatos> <20130328184827.29679.62426.stgit@warthog.procyon.org.uk> <20130328184835.29679.62285.stgit@warthog.procyon.org.uk>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the former is used in a.out.h
Date: Thu, 28 Mar 2013 22:32:53 +0000
Message-ID: <32349.1364509973@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> I'm a little bit confused about your description for the second one.
> Did you need to change the #defines names because they could conflict
> with other drivers when the xHCI driver is built in?  Or is there some
> other point I'm missing?

Sorry, I should say.  I'm trying to clean up the UAPI headers and I noticed
that the xHCI SEGMENT_SIZE macro is named the same as one defined by a.out.h
that cannot be changed as it is seen by userspace.  Although it's unlikely
that within the kernel they are unlikely to collide, one cannot be entirely
sure that will stay true as new arches get added (hopefully no one will add
new arches that use a.out format).  It seems best that the xHCI one be renamed
if possible.

> Are these feature patches for 3.10, or bug fixes for 3.9?  If they're
> for 3.9, should they go into stable?  My inclination is the first patch
> shouldn't but I'm not sure about this one.

Both are aimed at 3.10.  Neither are fixes for extant bugs that I know of.

David
