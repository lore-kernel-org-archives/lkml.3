Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaIXV7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:59:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaIXV73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:59:29 -0400
Date: Wed, 24 Sep 2014 14:59:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: softdirty: keep bit when zapping file pte
Message-Id: <20140924145927.04e8eb7ba6c1410a797293c7@linux-foundation.org>
In-Reply-To: <1411200187-40896-1-git-send-email-pfeiner@google.com>
References: <1411200187-40896-1-git-send-email-pfeiner@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2014 01:03:07 -0700 Peter Feiner <pfeiner@google.com> wrote:

> Fixes the same bug as b43790eedd31e9535b89bbfa45793919e9504c34 and
> 9aed8614af5a05cdaa32a0b78b0f1a424754a958 where the return value of
> pte_*mksoft_dirty was being ignored.
> 
> To be sure that no other pte/pmd "mk" function return values were
> being ignored, I annotated the functions in
> arch/x86/include/asm/pgtable.h with __must_check and rebuilt.
> 

Grumble.

It is useful to identify preceding similar patches but that isn't a
good way of describing *this* patch.  What is wrong with the current
code, how does the patch fix it.

And, particularly, what do you think are the end-user visible effects
of the bug?  This info helps people to work out which kernel versions
need the fix.

