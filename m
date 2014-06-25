Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaFYM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:56:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50506 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaFYM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:56:21 -0400
Date: Wed, 25 Jun 2014 13:54:21 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/21] kGraft
Message-ID: <20140625135421.67cd5f5f@alan.etchedpixels.co.uk>
In-Reply-To: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 13:05:29 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> Hi,
> 
> this is a repost of the second round of RFC on kGraft, the linux
> kernel online patching developed at SUSE. This repost only widened the
> target audience for broader review, no code change happened.

-		wait_event_freezable(khubd_wait,
+		wait_event_freezable(khubd_wait,
  ({ kgr_task_safe(current);

The changes are somewhat ugly with all the kgraft crap leaking into plces
like jbd and freezer and usb. That says to me its not well isolated and
there must be a better way of hiding that kgr stuff so we don't have to
kepe putting more code into all the kthreads, and inevitably missing them
or have people getting it wrong.

You also wake up all the kthreads when some of them might not expect to
be woken and may not check for the case of a bogus wake.

You add instructions to various hotpaths (despite the CONFIG comment).
Have you done timing analysis of their impact when turned on ?

Can you explain a bit more about why the path you've chosen was used as
opposed to using the power management freeze/resume path. Would that not
be a lot less intrusive ?

Don't get me wrong - I'd like a good working ksplice/graft !

Alan
