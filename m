Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3LLSis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:38:48 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:62596 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3LLSio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:38:44 -0500
MIME-Version: 1.0
In-Reply-To: <1386870022-31525-1-git-send-email-will.deacon@arm.com>
References: <1386870022-31525-1-git-send-email-will.deacon@arm.com>
Date: Thu, 12 Dec 2013 10:38:43 -0800
X-Google-Sender-Auth: MDnMMcdSYInq7NTKJWm7Rvcsghw
Message-ID: <CA+55aFz1RwjjbdauN+Y3hbk079KTbeoXb__BHAbO+vOOb5qD6w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dcache: allow word-at-a-time name hashing with
 big-endian CPUs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, looks good. So I'm taking these even though it's outside the merge
window - they're small, and until you enable DCACHE_WORD_ACCESS on
big-endian they don't actually do anything.

Ben - you might want to check if this makes DCACHE_WORD_ACCESS useful
on PowerPC too. Right now that requires an efficient fls()
implementation, but I think you have "cntlz" like ARM does.

                 Linus
