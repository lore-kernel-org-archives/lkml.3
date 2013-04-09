Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab3DIUWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:22:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3DIUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:22:03 -0400
Date: Tue, 9 Apr 2013 13:22:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Chanho Min" <chanho.min@lge.com>
Cc: "'Nadia Yvette Chambers'" <nyc@holomorphy.com>,
        "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Guennadi Liakhovetski'" <lg@denx.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] bitmap: speedup in bitmap_find_free_region when
 order is 0
Message-Id: <20130409132202.a73a059ab2b57d47d6f1652b@linux-foundation.org>
In-Reply-To: <5163b689.64d3440a.731b.ffff9984SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
	<20130408201001.f4c74887.akpm@linux-foundation.org>
	<5163b689.64d3440a.731b.ffff9984SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013 15:34:44 +0900 "Chanho Min" <chanho.min@lge.com> wrote:

> >It seems excessively complicated to me.  Why not change
> >bitmap_find_free_region() to skip the leading all-ones words and when
> >it finds a not-all-ones word, adjust `pos' then fall into the existing
> >bit-at-a-time search?
> 
> Do we need the additional 'if' inside the for loop for implementing it?

It was just a concept - there are various ways of optimizing a real
implementation.  Move the code into userspace then run some
microbenchmarks.

> I thought the separation of the routine for order=0 is the way to avoid
> the impact on the existing codes and its performance.

The existing code doesn't have any performance ;) It's so darn slow
that even a minor effort here will yield large (ie order-of-magnitude)
performance improvements.
