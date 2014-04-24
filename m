Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbaDXWV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:21:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbaDXWVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:21:21 -0400
Date: Fri, 25 Apr 2014 00:21:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Rientjes <rientjes@google.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
In-Reply-To: <alpine.DEB.2.02.1404241518210.24983@chino.kir.corp.google.com>
Message-ID: <alpine.LNX.2.00.1404250020370.8903@pobox.suse.cz>
References: <20140423125352.704f9fb2@annuminas.surriel.com> <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz> <20140424005247.GA17713@logfs.org> <20140424194024.GA25446@logfs.org> <20140424195821.GA3092@kroah.com> <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
 <alpine.DEB.2.02.1404241518210.24983@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, David Rientjes wrote:

> > Well, if you have dmesg dump from panic that happens every other year, and 
> > you have to do post-mortem analysis on it, I am pretty sure you would love 
> > to be able to figure out how the stack traces would look like without 
> > inter-CPU interleaving. And I am pretty sure you wouldn't want to 
> > insert/enable a tracepoint and wait another two years for the bug to 
> > trigger again.
> 
> Sounds like the appropriate fix would be to serialize stack dumping to the 
> kernel log.

That's rather difficult, as it can be done both from NMI and non-NMI 
contexts, and those are very hard to synchronize.

-- 
Jiri Kosina
SUSE Labs
