Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3CLIVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:21:18 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:42439 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3CLIVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:21:17 -0400
Date: Tue, 12 Mar 2013 09:21:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
Message-ID: <20130312082112.GB30665@gmail.com>
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> @@ -31,7 +32,7 @@
>  #error Wordsize not 32 or 64
>  #endif
>  
> -static inline u64 hash_64(u64 val, unsigned int bits)
> +static __kprobes inline u64 hash_64(u64 val, unsigned int bits)
>  {
>  	u64 hash = val;

We should also, really, really fix the '__kprobes' misnomer and switch to 
the '__noprobe' pattern or so. The naming does not make it obvious at all 
that what we do here is to turn _off_ kprobing of select functions...

The only complication is that __kprobes is now present in 600+ places, 
which will create merge conflicts. If you remind me during the next merge 
window I can generate the rename on the spot and send it to Linus without 
anyone having to carry the patch for too long.

Thanks,

	Ingo
