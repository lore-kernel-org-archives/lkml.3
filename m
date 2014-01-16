Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaAPGAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:00:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47840 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaAPGAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:00:00 -0500
Date: Thu, 16 Jan 2014 05:59:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat: fix sys_fanotify_mark
Message-ID: <20140116055946.GX10323@ZenIV.linux.org.uk>
References: <20140115114557.GC6638@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115114557.GC6638@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:45:57PM +0100, Heiko Carstens wrote:
> 91c2e0bcae72 "unify compat fanotify_mark(2), switch to COMPAT_SYSCALL_DEFINE"
> added a new unified compat fanotify_mark syscall to be used by all
> architectures.
> Unfortunately the unified version merges the split mask parameter in a
> wrong way: the lower and higher word got swapped.

Nice catch; ACK and that should go into -stable starting with 3.10.
