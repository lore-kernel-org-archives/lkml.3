Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3HUUiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:38:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3HUUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:38:07 -0400
Date: Wed, 21 Aug 2013 13:38:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: riel@redhat.com, jack@suse.cz, dev@parallels.com, miklos@szeredi.hu,
        fuse-devel@lists.sourceforge.net, xemul@parallels.com,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        linux-mm@kvack.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, fengguang.wu@intel.com,
        devel@openvz.org, mgorman@suse.de
Subject: Re: [PATCH] mm: strictlimit feature -v4
Message-Id: <20130821133804.87ca602dd864df712e67342a@linux-foundation.org>
In-Reply-To: <20130821135427.20334.79477.stgit@maximpc.sw.ru>
References: <20130821135427.20334.79477.stgit@maximpc.sw.ru>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 17:56:32 +0400 Maxim Patlasov <mpatlasov@parallels.com> wrote:

> The feature prevents mistrusted filesystems to grow a large number of dirty
> pages before throttling. For such filesystems balance_dirty_pages always
> check bdi counters against bdi limits. I.e. even if global "nr_dirty" is under
> "freerun", it's not allowed to skip bdi checks. The only use case for now is
> fuse: it sets bdi max_ratio to 1% by default and system administrators are
> supposed to expect that this limit won't be exceeded.
> 
> The feature is on if a BDI is marked by BDI_CAP_STRICTLIMIT flag.
> A filesystem may set the flag when it initializes its BDI.

Now I think about it, I don't really understand the need for this
feature.  Can you please go into some detail about the problematic
scenarios and why they need fixing?  Including an expanded descritopn
of the term "mistrusted filesystem"?

Is this some theoretical happens-in-the-lab thing, or are real world
users actually hurting due to the lack of this feature?

I think I'll apply it to -mm for now to get a bit of testing, but would
very much like it if Fengguang could find time to review the
implementation, please.

