Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbaDXWR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:17:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbaDXWRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:17:53 -0400
Date: Thu, 24 Apr 2014 15:20:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140424222046.GB4098@kroah.com>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
 <20140424195821.GA3092@kroah.com>
 <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:12:06AM +0200, Jiri Kosina wrote:
> On Thu, 24 Apr 2014, Greg Kroah-Hartman wrote:
> 
> > > +#ifdef CONFIG_PRINTK_CPU
> > > +	if (!buf)
> > > +		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",
> > 
> > %02x for a cpu?  What happens on machines with 8k cpus?
> 
> Ummm ... what issue do you see here, Greg? It'll print 0x1f40, no?

Yes, just not be as "pretty" and aligned properly :)

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

Fair enough, and the multi-oops message drives that home.

But does this break things like 'dmesg --human' mode that is in
util-linux?

thanks,

greg k-h
