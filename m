Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3IOGJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 02:09:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:51180 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab3IOGJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 02:09:08 -0400
Message-ID: <1379225343.5545.154.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] ipc/sem.c: Race in sem_lock()
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com
Date: Sun, 15 Sep 2013 08:09:03 +0200
In-Reply-To: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
References: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:EqqqVLgLtCT8BvdxDWJQWvdpIPLZht8kX1nhdyeVTYWa/fg7IFe
 xZRyt4AxRwd7WMhcg5SzZa9/AtpMUwAgkT+62UyBlOdrsd4Hl+mwtBboeNGQudkz4GinnCC
 veL2Gt8iVYJoOPn/+XMmHh9SZsTywV3aAyyeL7sMaQZPOZ9vFNnXvRzYVSFPOoYSn4k/cFQ
 jKCV2jzuINZGGwUqNgxeA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-14 at 23:34 +0200, Manfred Spraul wrote:

> The bug is probably also present in 3.10 and 3.11, but for these kernels
> is is probably simpler just to move the test of sma->complex_count after
> the spin_is_locked() test.

IMHO, your 6 patch series should go to stable as well.  Scalability is
still BAD without them.  Now, you've shown the lock split to be buggy.

Logically, the whole thing should be reverted entirely in stable, or
fixed up properly.  Humongous improvements will find their way into
every long term stable kernel on the planet regardless, so..

Stable may as well do the Borg thing, resistance really is futile ;-)

-Mike

