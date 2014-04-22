Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaDVTKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:10:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbaDVTJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:09:42 -0400
Date: Tue, 22 Apr 2014 15:09:28 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: 3.15rc2 hanging processes on exit.
Message-ID: <20140422190928.GA25183@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>
References: <20140422180308.GA19038@redhat.com>
 <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:57:50AM -0700, Linus Torvalds wrote:
 
 > Are you testing anything new? Or is this strictly new to 3.15? The
 > only thing in this area we do differently is commit cda540ace6a1 ("mm:
 > get_user_pages(write,force) refuse to COW in shared areas"), but
 > fault_in_user_writeable() never used the force bit afaik. Adding Hugh
 > just in case.

You mean new as in additions to trinity ?
The only recent chance that might be relevant is that now, when I create
struct iovec's to pass to syscalls, I populate them solely with results
from mmap's rather than a mix of mmaps and mallocs.  The mmaps could be
all kinds of sizes, types etc. [*]  So now there's more chance I guess
that an iovec contains a bunch of hugepages, or read-only pages etc.

I took another slightly longer trace of what's going on at
http://codemonkey.org.uk/junk/trace2.out
But it looks to me to be pretty similar.

	Dave

[*] https://github.com/kernelslacker/trinity/commit/1e73841971717256089d63e9f7fc33972d48028c
