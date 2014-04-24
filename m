Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbaDXWTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:19:00 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37851 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbaDXWSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:18:54 -0400
Date: Thu, 24 Apr 2014 15:18:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiri Kosina <jkosina@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
In-Reply-To: <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
Message-ID: <alpine.DEB.2.02.1404241518210.24983@chino.kir.corp.google.com>
References: <20140423125352.704f9fb2@annuminas.surriel.com> <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz> <20140424005247.GA17713@logfs.org> <20140424194024.GA25446@logfs.org> <20140424195821.GA3092@kroah.com>
 <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Jiri Kosina wrote:

> > > +#ifdef CONFIG_PRINTK_CPU
> > > +	if (!buf)
> > > +		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",
> > 
> > %02x for a cpu?  What happens on machines with 8k cpus?
> 
> Ummm ... what issue do you see here, Greg? It'll print 0x1f40, no?
> 

I think he's referring to the alignment with %02x.

> > And is this really an issue?  Debugging by using printk is fun, but not 
> > really something that people need to add a cpu number to.  Why not just 
> > use a tracepoint in your code to get the needed information instead?
> 
> Well, if you have dmesg dump from panic that happens every other year, and 
> you have to do post-mortem analysis on it, I am pretty sure you would love 
> to be able to figure out how the stack traces would look like without 
> inter-CPU interleaving. And I am pretty sure you wouldn't want to 
> insert/enable a tracepoint and wait another two years for the bug to 
> trigger again.
> 

Sounds like the appropriate fix would be to serialize stack dumping to the 
kernel log.
