Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaEVCeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:34:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEVCeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:34:14 -0400
Date: Wed, 21 May 2014 19:33:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/4] pagecache scanning with /proc/kpagecache
Message-Id: <20140521193336.5df90456.akpm@linux-foundation.org>
In-Reply-To: <537d5ee4.4914e00a.5672.ffff85d5SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1400639194-3743-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20140521154250.95bc3520ad8d192d95efe39b@linux-foundation.org>
	<537d5ee4.4914e00a.5672.ffff85d5SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 22:19:55 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> > A much nicer interface would be for us to (finally!) implement
> > fincore(), perhaps with an enhanced per-present-page payload which
> > presents the info which you need (although we don't actually know what
> > that info is!).
> 
> page/pfn of each page slot and its page cache tag as shown in patch 4/4.
> 
> > This would require open() - it appears to be a requirement that the
> > caller not open the file, but no reason was given for this.
> > 
> > Requiring open() would address some of the obvious security concerns,
> > but it will still be possible for processes to poke around and get some
> > understanding of the behaviour of other processes.  Careful attention
> > should be paid to this aspect of any such patchset.
> 
> Sorry if I missed your point, but this interface defines fixed mapping
> between file position in /proc/kpagecache and in-file page offset of
> the target file. So we do not need to use seq_file mechanism, that's
> why open() is not defined and default one is used.
> The same thing is true for /proc/{kpagecount,kpageflags}, from which
> I copied/pasted some basic code.

I think you did miss my point ;) Please do a web search for fincore -
it's a syscall similar to mincore(), only it queries pagecache:
fincore(int fd, loff_t offset, ...).  In its simplest form it queries
just for present/absent, but we could increase the query payload to
incorporate additional per-page info.

It would take a lot of thought and discussion to nail down the
fincore() interface (we've already tried a couple of times).  But
unfortunately, fincore() is probably going to be implemented one day
and it will (or at least could) make /proc/kpagecache obsolete.

