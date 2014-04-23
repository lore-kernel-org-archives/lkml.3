Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaDWVjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:39:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaDWVjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:39:44 -0400
Date: Wed, 23 Apr 2014 23:39:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        joern@logfs.org, peterz@infradead.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
In-Reply-To: <20140423130453.32361ca9ceef591b9b184926@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1404232338200.1491@twin.jikos.cz>
References: <20140423125352.704f9fb2@annuminas.surriel.com> <20140423130453.32361ca9ceef591b9b184926@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Andrew Morton wrote:

> > Echoing values into /proc/sysrq-trigger seems to be a popular way to
> > get information out of the kernel. However, dumping information about
> > thousands of processes, or hundreds of CPUs to serial console can
> > result in IRQs being blocked for minutes, resulting in various kinds
> > of cascade failures.
> > 
> > The most common failure is due to interrupts being blocked for a very
> > long time. This can lead to things like failed IO requests, and other
> > things the system cannot easily recover from.
> 
> I bet nobody wants that console output anyway.  You do the sysrq then
> run dmesg or look in /var/log/messages to see what happened.  People
> who are experiencing problems such as this should run `dmesg -n 1'
> before writing to sysrq-trigger.

I don't agree. I have used sysrq-t multiple times in situations where 
userspace was already dead, but sysrq was still able to provide valuable 
information about the state of the kernel.

-- 
Jiri Kosina
SUSE Labs

