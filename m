Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaCKG2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:28:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:12924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaCKG2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:28:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="470004508"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove compat vdso support
References: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
Date: Mon, 10 Mar 2014 23:28:33 -0700
In-Reply-To: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Mon, 10 Mar 2014 17:12:31 -0700")
Message-ID: <878ushgsfi.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> The compat vDSO is a complicated hack that's needed to maintain
> compatibility with a small range of never-released glibc versions.
>
> This removes it and replaces it with a much simpler hack: a config
> option to disable the 32-bit vDSO by default.

Nack!

That breaks at least one SUSE version.

And I don't want to break performance completely there either.
int 0x80 is just too slow.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
