Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaA2UTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:19:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaA2UTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:19:01 -0500
Date: Wed, 29 Jan 2014 12:18:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, criu@openvz.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Borislav Petkov <bp@suse.de>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH] mm: don't lose the SOFT_DIRTY flag on mprotect
Message-Id: <20140129121859.07da0df20daea6a1581e709a@linux-foundation.org>
In-Reply-To: <1391025899-25299-1-git-send-email-avagin@openvz.org>
References: <1391025899-25299-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 00:04:59 +0400 Andrey Vagin <avagin@openvz.org> wrote:

> The SOFT_DIRTY bit shows that the content of memory was changed
> after a defined point in the past. mprotect() doesn't change the
> content of memory, so it must not change the SOFT_DIRTY bit.
> 
> This patch does nothing with _PAGE_SWP_SOFT_DIRTY, becase pte_modify()
> is called only for present pages.

Standard complaint: when fixing a bug, please describe the end-user
visible effects of that bug.

afaict the effects are minor: snapshotting will save/copy more pages
than it needs to, but there will be no malfunction.  Hence a -stable
backport is unneeded.  Agree?


