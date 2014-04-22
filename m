Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaDVUdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638AbaDVUcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:32:55 -0400
Date: Tue, 22 Apr 2014 16:32:44 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: 3.15rc2 hanging processes on exit.
Message-ID: <20140422203244.GA30757@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>
References: <20140422180308.GA19038@redhat.com>
 <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
 <alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:17:33PM -0700, Hugh Dickins wrote:
 
 > Your patch looks to me correct and to the point; but I agree that
 > we haven't made a relevant change there recently, so I suppose it
 > comes from a trinity improvement rather than a new bug in 3.15.
 > 
 > (Dave, do you have time to confirm that by running new trinity on 3.14?)

I can give it a shot.

I think perhaps a bigger reason why this might be only just turning up,
is that I now have an upper bound on the number of entries in an iovec
at 256 entries.  So now there's more chance that we'll generate an iovec
that a syscall can actually use instead of us running out of memory
trying to satisfy every entry and constructing a broken iovec struct if
we hit ENOMEM

	Dave

