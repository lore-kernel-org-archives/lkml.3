Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3A0T5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:57:35 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:40662 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3A0T5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:57:32 -0500
Date: Sun, 27 Jan 2013 20:57:14 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130127195714.GA11224@samfundet.no>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 27 Jan 2013 13:50:15 +0100 or thereabout, Matthias Brugger wrote:
> This patch adds dummy syscalls so that compiling
> for this architecture does not provoke warnings when
> checksyscalls.sh is called.

Does any of these syscalls take more than 5 arguments? If so, it is also
needed to do some stack handling. I would rather not add syscalls that cause
the kernel to misbehave.

> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  arch/avr32/include/asm/unistd.h      |  2 +-
>  arch/avr32/include/uapi/asm/unistd.h | 29 +++++++++++++++++++++++++++++
>  arch/avr32/kernel/syscall_table.S    | 29 +++++++++++++++++++++++++++++
>  3 files changed, 59 insertions(+), 1 deletion(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
