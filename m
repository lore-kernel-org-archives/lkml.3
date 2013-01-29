Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3A2KuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:50:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42377 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3A2KuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:50:00 -0500
Date: Tue, 29 Jan 2013 11:49:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/2] perf: Make -lnuma optional
Message-ID: <20130129104958.GC14302@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1359456492-22156-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359456492-22156-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 11:48:12AM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> a0c17eadf3bf9 ("perf: Add 'perf bench numa mem' NUMA performance
> measurement suite") added -lnuma to the EXTLIBS but we use those when
> checking for other libraries like libelf, libunwind, etc and the checks
> failed even when the dev libraries are installed on the system:
> 
>     CHK libelf
> /usr/bin/ld: cannot find -lnuma
> collect2: error: ld returned 1 exit status
>     CHK glibc
> Makefile:552: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
>     CHK libunwind
> /usr/bin/ld: cannot find -lnuma
> collect2: error: ld returned 1 exit status
> Makefile:586: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99
> ...
> 
> So, add glue to detect the presence of -lnuma and build perf bench numa
> only then.

While at it, I noticed another annoyance: if FLEX and BISON are needed
unconditionally for the build, this needs to be checked at the beginning
of the makefile and make shouldn't fail in-between. Oh well, I'll let
someone beat me to it with a fix since I'm lazy :).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
