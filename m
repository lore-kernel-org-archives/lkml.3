Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3IPGiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:38:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3IPGiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:38:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: Why does test_bit() take a volatile addr?
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 16 Sep 2013 13:38:35 +0930
Message-ID: <87ioy11k8s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Predates git, does anyone remember the rationale?

ie:
        int test_bit(int nr, const volatile unsigned long *addr)

I noticed because gcc failed to elimiate some code in a patch I was
playing with.

I'm nervous about subtle bugs involved in ripping it out, even if noone
knows why.  Should I add __test_bit()?

Thanks,
Rusty.
