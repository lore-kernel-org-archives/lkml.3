Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaEUWm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:42:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaEUWmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:42:54 -0400
Date: Wed, 21 May 2014 15:42:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/4] pagecache scanning with /proc/kpagecache
Message-Id: <20140521154250.95bc3520ad8d192d95efe39b@linux-foundation.org>
In-Reply-To: <1400639194-3743-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1400639194-3743-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 22:26:30 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> This patchset adds a new procfs interface to extrace information about
> pagecache status. In-kernel tool tools/vm/page-types.c has already some
> code for pagecache scanning without kernel's help, but it's not free
> from measurement-disturbance, so here I'm suggesting another approach.

I'm not seeing much explanation of why you think the kernel needs this.
The overall justification for a change is terribly important so please
do spend some time on it.

As I don't *really* know what the patch is for, I can't comment a lot
further, but...


A much nicer interface would be for us to (finally!) implement
fincore(), perhaps with an enhanced per-present-page payload which
presents the info which you need (although we don't actually know what
that info is!).

This would require open() - it appears to be a requirement that the
caller not open the file, but no reason was given for this.

Requiring open() would address some of the obvious security concerns,
but it will still be possible for processes to poke around and get some
understanding of the behaviour of other processes.  Careful attention
should be paid to this aspect of any such patchset.


