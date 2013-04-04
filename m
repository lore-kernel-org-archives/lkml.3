Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3DDDIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 23:08:48 -0400
Received: from ozlabs.org ([203.10.76.45]:44854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761971Ab3DDDIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 23:08:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer at kset_find_obj
In-Reply-To: <10041.1364984307@warthog.procyon.org.uk>
References: <874nfo5em2.fsf@rustcorp.com.au> <1484037905.443048.1364884090669.JavaMail.root@redhat.com> <19926.1364924330@warthog.procyon.org.uk> <10041.1364984307@warthog.procyon.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 04 Apr 2013 11:17:37 +1030
Message-ID: <87sj373yvq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Btw, one thing I've noticed is that sysfs appears to be able to execute code
> in the module by way of parameter alterations before the module is completely
> set up.

It's preceeded by the module parameter parsing, which can do the same
thing, so I don't think it's an issue.

> I'm not sure this is an actual problem - but it might give an
> interesting interaction with module initialisers as they might reasonably
> expect that module parameters can't change whilst they're running.

This is possible, but most changable parameters are very simple.  There
are a few users of kparam_block_sysfs_write(), but not many...

Cheers,
Rusty.
