Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbaDIUou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:44:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590AbaDIUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:44:49 -0400
Date: Wed, 9 Apr 2014 13:44:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wengang <wen.gang.wang@oracle.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/1] OCFS2: Remove NULL assignments on
 static
Message-Id: <20140409134448.cb23b34622bf986d145f1eaa@linux-foundation.org>
In-Reply-To: <534499FA.8010107@oracle.com>
References: <20140408221342.9759bea1dd852f2787f82586@skynet.be>
	<534499FA.8010107@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014 08:53:14 +0800 Wengang <wen.gang.wang@oracle.com> wrote:

> ___ 2014___04___09___ 04:13, Fabian Frederick ______:
> > static values are automatically initialized to NULL.
> >
>
> What's the badness if we do the assignments?

(top-posting repaired...)

Back in the olden days,

	static int x = 0;

would consume space in the .data segment and

	static int x;

would consume space in the .bss segment.


The .data segment is a part of vmlinux (because it contains non-zero
data) whereas .bss does not occupy space in vmlinux because .bss is
all-zero and can be built at runtime

So the effect of this patch would be to reduce the size of the kernel
image.  Less disk space, less ROM space, etc.


I think more recent gcc's and linkers got smarter about that and move
initialized-to-zero .data into .bss anyway.

