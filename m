Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaFRV3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:29:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaFRV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:29:32 -0400
Date: Wed, 18 Jun 2014 14:29:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] /proc/stat vs. failed order-4 allocation
Message-Id: <20140618142931.857d57fe0007a361404f6cab@linux-foundation.org>
In-Reply-To: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 11:04:50 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> These two patches are supposed to "fix" failed order-4 memory
> allocations which have been observed when reading /proc/stat.
> The problem has been observed on s390 as well as on x86.
> 
> To address the problem change the seq_file memory allocations to
> fallback to use vmalloc, so that allocations also work if memory
> is fragmented.
> 
> This approach seems to be simpler and less intrusive than changing
> /proc/stat to use an interator. Also it "fixes" other users as well,
> which use seq_file's single_open() interface.

Yes, those changes look pretty simple and effective.

I'm unclear on how urgent these fixes are.  I semi-randomly tagged them
for 3.16 with a -stable backport, but that could be changed?

