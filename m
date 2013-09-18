Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3IRJSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:18:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58402 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab3IRJSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:18:30 -0400
Date: Wed, 18 Sep 2013 10:17:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: Commit breaks strace: ARM: entry: allow ARM-private syscalls to
 be restarted
Message-ID: <20130918091748.GA1783@mudshark.cambridge.arm.com>
References: <20130917215749.GA11109@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917215749.GA11109@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:57:49PM +0100, Jason Gunthorpe wrote:
> Hi Will,

Hi Jason,

> I was just testing v3.12-rc1 (on kirkwood) and noticed that strace is
> not working:

Thanks for the report!

> $ strace /bin/ls
> mmap2(0xb6f79000, 9552, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f79000
> close(3)                                = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fad000
> set_tls(0xb6fad4c0, 0xb6fadb98, 0xb6fb1050, 0xb6fad4c0, 0xb6fb1050) = -1 ENOSYS (Function not implemented)
> writev(2, [{"cannot set up thread-local stora"..., 36}, {"unknown error", 13}, {"\n", 1}], 3cannot set up thread-local storage: unknown error
> ) = 50
> exit_group(127)                         = ?
> +++ exited with 127 +++
> 
> I determined that reverting your commit below makes strace work again.
> I've tested 3.10.12 and it is OK.

Hmm, so if you don't run with strace, does `/bin/ls' work as expected? From
the trace above, it seems that set_tls is failing rather than anything in
strace (unless of course, the trace is just plain wrong).

> This happens with the latest git head for strace, as well as the 4.7
> release.
> 
> Hopefully you can cook up a fix :)

I'll take a look today, thanks.

Will
