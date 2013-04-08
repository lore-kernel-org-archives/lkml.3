Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936003Ab3DHMwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:52:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51579 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935987Ab3DHMwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:52:04 -0400
Date: Mon, 8 Apr 2013 14:51:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130408125129.GC4395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stefan Bader <stefan.bader@canonical.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
 <20130406154751.GB3612@pd.tnic>
 <20130408115344.GA7513@gmail.com>
 <20130408115959.GB4395@pd.tnic>
 <5162B7FF.7010603@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5162B7FF.7010603@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 02:28:47PM +0200, Stefan Bader wrote:
> To enforce the PSE bit here sounds reasonably right. And also apply
> canon_pgprot, too. GLOBAL I don't know for sure.

Well sure, you don't want to flush those from the TLB if it is kernel
memory since it is mapped in every process AFAICT.

> By the way there is a usage of new_prot a bit down of
> try_preserve_large_page which probably should be changed into
> req_prot, too. That was enforcing the canon_pgprot before the change.
> So that may be considered a regression to before.

Which one?

Actually, after Andrea's patch it all makes sense - we initialize
new_prot from req_prot *after* all protections checks. new_prot are,
IMHO, the final protection bits which we are actually going to change.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
