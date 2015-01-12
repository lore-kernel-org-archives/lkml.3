Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbbALXJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:09:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbALXJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:09:23 -0500
Date: Mon, 12 Jan 2015 15:09:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@linux.intel.com
Subject: Re: [PATCH v12 00/20] DAX: Page cache bypass for filesystems on
 memory storage
Message-Id: <20150112150921.d9e8e46f9bb5d76d8cfb3fbc@linux-foundation.org>
In-Reply-To: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:32 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> DAX is a replacement for the variation of XIP currently supported by
> the ext2 filesystem.

Looks pretty nice to me, thanks.  I had a bunch of relatively minor
review questions - mainly stuff which would benefit from some short
comments.

I had to do some mangling due to the intervening
i_mmap_mutex->i_mmap_lock_read/write.  I ended up choosing
i_mmap_lock_read() throughout, which needs careful checking please.  I
also converted the changelogs.  It still compiles!

