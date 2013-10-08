Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab3JHAuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:50:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3JHAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:50:17 -0400
Date: Mon, 7 Oct 2013 17:50:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] page-types.c: support KPF_SOFTDIRTY bit
Message-Id: <20131007175016.a513865c5ecae4bd5759c2b0@linux-foundation.org>
In-Reply-To: <1380913335-17466-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1380913335-17466-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1380913335-17466-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Oct 2013 15:02:15 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Soft dirty bit allows us to track which pages are written since the
> last clear_ref (by "echo 4 > /proc/pid/clear_refs".) This is useful
> for userspace applications to know their memory footprints.
> 
> Note that the kernel exposes this flag via bit[55] of /proc/pid/pagemap,
> and the semantics is not a default one (scheduled to be the default in
> the near future.) However, it shifts to the new semantics at the first
> clear_ref, and the users of soft dirty bit always do it before utilizing
> the bit, so that's not a big deal. Users must avoid relying on the bit
> in page-types before the first clear_ref.

Is Documentation/filesystems/proc.txt (around line 450) fully up to
date here?

