Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaDXXaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:30:18 -0400
Received: from longford.logfs.org ([213.229.74.203]:43208 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaDXXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:30:16 -0400
Date: Thu, 24 Apr 2014 19:29:16 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140424232916.GD25446@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
 <20140424195821.GA3092@kroah.com>
 <alpine.LNX.2.00.1404250005020.8903@pobox.suse.cz>
 <alpine.DEB.2.02.1404241518210.24983@chino.kir.corp.google.com>
 <alpine.LNX.2.00.1404250020370.8903@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1404250020370.8903@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 April 2014 00:21:20 +0200, Jiri Kosina wrote:
> On Thu, 24 Apr 2014, David Rientjes wrote:
> 
> > > Well, if you have dmesg dump from panic that happens every other year, and 
> > > you have to do post-mortem analysis on it, I am pretty sure you would love 
> > > to be able to figure out how the stack traces would look like without 
> > > inter-CPU interleaving. And I am pretty sure you wouldn't want to 
> > > insert/enable a tracepoint and wait another two years for the bug to 
> > > trigger again.
> > 
> > Sounds like the appropriate fix would be to serialize stack dumping to the 
> > kernel log.
> 
> That's rather difficult, as it can be done both from NMI and non-NMI 
> contexts, and those are very hard to synchronize.

It is also easy to get wrong and cause a panic() that doesn't reboot
but instead gets stuck somewhere.

Plus, you might want similar serialization for other multi-line debug
messages.  Scsi error messages come to mind, but we have many more
examples.

Jörn

--
Any headline which ends in a question mark can be answered by the word 'no'.
-- Betteridge's Law
