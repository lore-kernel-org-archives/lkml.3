Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaJEUGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:06:17 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35074 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaJEUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
From: Jason Noakes <jjnoakes@gmail.com>
Date: Sun, 5 Oct 2014 16:05:54 -0400
Message-ID: <CAN2+FELPuQwt0Xr-r-dThXAeuec7wCtFKv+E+6GSQOG7wJqE3w@mail.gmail.com>
Subject: Fwd: kobject_init and the zeroed-out-memory requirement
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that kobject_init() requres the kobject passed in to be
zeroed out fully first.

Many other *_init kernel routines (cdev_init, kref_init, mutex_init,
spin_lock_init, etc) do not have the same requirement - they work on
fully uninitialized memory.

Documentation/kobject.txt does not mention the requirement that the
memory be zero-initialized before it is passed to kobject_init.

I would like to submit a patch - which solution is preferred?

  (a) Update Documentation/kobject.txt and explicitly add the requirement
  (b) Modify kobject_init to zero out the memory itself like other
*_init routines
        (It already initializes most of its members - just not all of them)
  (c) Something else?

Your preference?

(Please CC: me on replies).

-- 
~~ Jason J. Noakes
~~ jjnoakes@gmail.com
