Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3HUWK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:10:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3HUWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:10:27 -0400
Date: Wed, 21 Aug 2013 15:10:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: bsingharora@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/delayacct.c: check NULL for member variable
 'delays' in all extern functions.
Message-Id: <20130821151025.77673f0f3cad748a80086a16@linux-foundation.org>
In-Reply-To: <5212D703.5080405@asianux.com>
References: <5212D703.5080405@asianux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 10:40:03 +0800 Chen Gang <gang.chen@asianux.com> wrote:

> The member variable 'delays' may be NULL, so need check NULL before use
> it for all extern functions, just like __delayacct_tsk_init() and
> __delayacct_add_tsk() have already done.

If task.delays is NULL, the kernel will oops.  I don't recall seeing
such oops reports hence I suspect that you missed some check somewhere.

For example, delayacct_blkio_start() checks current->delays before
calling __delayacct_blkio_start(), so why retest current->delays in
__delayacct_blkio_start()?
