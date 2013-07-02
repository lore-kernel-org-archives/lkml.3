Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3GBCAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:00:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:49435 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab3GBCAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:00:44 -0400
Message-ID: <1372730420.4820.21.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 12:00:20 +1000
In-Reply-To: <20130702105415.8579055c3539bbb3e3cacfbc@canb.auug.org.au>
References: <20130702105415.8579055c3539bbb3e3cacfbc@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 10:54 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the powerpc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/pstore/ftrace.c: In function 'pstore_ftrace_call':
> fs/pstore/ftrace.c:47:6: warning: passing argument 7 of 'psinfo->write_buf' makes integer from pointer without a cast [enabled by default]
>       sizeof(rec), psinfo);
>       ^
> fs/pstore/ftrace.c:47:6: note: expected 'size_t' but argument is of type 'struct pstore_info *'
> fs/pstore/ftrace.c:47:6: error: too few arguments to function 'psinfo->write_buf'
> 
> Caused by commit 6bbbca735936 ("pstore: Pass header size in the pstore
> write callback").
> 
> I have used the version from next-20130701 for today.

Interestingly enough I didn't see that when testing a x86_64 build, I
might have failed to test with ftrace enabled.

Aruna, please send a fix ASAP.

Cheers,
Ben.


