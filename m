Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3BLUNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:13:30 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56664 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3BLUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:13:27 -0500
Date: Tue, 12 Feb 2013 12:13:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Steven Whitehouse <swhiteho@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [patch for-3.8] fs, dlm: fix build error when EXPERIMENTAL is
 disabled
In-Reply-To: <CA+55aFzCRLy5AN24rJUvbLf5HNeumn=qtS0dA9f9+2CKOLgu7A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302121207250.25566@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com> <1360662605.2719.13.camel@menhir> <CA+55aFzCRLy5AN24rJUvbLf5HNeumn=qtS0dA9f9+2CKOLgu7A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013, Linus Torvalds wrote:

> On Tue, Feb 12, 2013 at 1:50 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> >
> > That doesn't seem right to me... DLM has not been experimental for a
> > long time now. Why not just select CRC32 in addition to IP_SCTP ?
> 
> Hmm. IP_SCTP already does a "select libcrc32c". So why doesn't that
> end up working?
> 

Kconfig won't select things that CONFIG_IP_SCTP select unless its "depends 
on" are satisfied, which is why I made CONFIG_DLM depend on 
CONFIG_EXPERIMENTAL.

Steven says DLM hasn't been experimental for a long time; sorry, but if an 
option you select is experimental then you're experimental as well.

If you'd like to push a patch that removes EXPERIMENTAL from IP_SCTP to 
David Miller, that works too.  But that is a completely separate topic 
from dlm.  For 3.8, I suggest respecting CONFIG_IP_SCTP's requirements and 
then removing EXPERIMENTAL from both if the networking guys agree.
