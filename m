Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaG3JD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:03:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaG3JDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:03:55 -0400
Date: Wed, 30 Jul 2014 02:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: BUG when __kmap_atomic_idx crosses boundary
Message-Id: <20140730020615.2f943cf7.akpm@linux-foundation.org>
In-Reply-To: <1406710355-4360-1-git-send-email-cpandya@codeaurora.org>
References: <1406710355-4360-1-git-send-email-cpandya@codeaurora.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014 14:22:35 +0530 Chintan Pandya <cpandya@codeaurora.org> wrote:

> __kmap_atomic_idx >= KM_TYPE_NR or < ZERO is a bug.
> Report it even if CONFIG_DEBUG_HIGHMEM is not enabled.
> That saves much debugging efforts.

Please take considerably more care when preparing patch changelogs.

kmap_atomic() is a very commonly called function so we'll need much
more detail than this to justify adding overhead to it.

I don't think CONFIG_DEBUG_HIGHMEM really needs to exist.  We could do
s/CONFIG_DEBUG_HIGHMEM/CONFIG_DEBUG_VM/g and perhaps your secret bug
whatever it was would have been found more easily.

