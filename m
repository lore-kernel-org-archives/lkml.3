Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaDXWMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:12:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbaDXWML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:12:11 -0400
Date: Fri, 25 Apr 2014 00:12:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
In-Reply-To: <20140424195821.GA3092@kroah.com>
Message-ID: <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
References: <20140423125352.704f9fb2@annuminas.surriel.com> <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz> <20140424005247.GA17713@logfs.org> <20140424194024.GA25446@logfs.org> <20140424195821.GA3092@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Greg Kroah-Hartman wrote:

> > +#ifdef CONFIG_PRINTK_CPU
> > +	if (!buf)
> > +		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",
> 
> %02x for a cpu?  What happens on machines with 8k cpus?

Ummm ... what issue do you see here, Greg? It'll print 0x1f40, no?

> And is this really an issue?  Debugging by using printk is fun, but not 
> really something that people need to add a cpu number to.  Why not just 
> use a tracepoint in your code to get the needed information instead?

Well, if you have dmesg dump from panic that happens every other year, and 
you have to do post-mortem analysis on it, I am pretty sure you would love 
to be able to figure out how the stack traces would look like without 
inter-CPU interleaving. And I am pretty sure you wouldn't want to 
insert/enable a tracepoint and wait another two years for the bug to 
trigger again.

-- 
Jiri Kosina
SUSE Labs
