Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaDWVlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:41:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaDWVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:41:19 -0400
Date: Wed, 23 Apr 2014 14:41:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        joern@logfs.org, peterz@infradead.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
Message-Id: <20140423144117.e5ce4b29a272b324b61d512c@linux-foundation.org>
In-Reply-To: <alpine.LRH.2.00.1404232338200.1491@twin.jikos.cz>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
	<20140423130453.32361ca9ceef591b9b184926@linux-foundation.org>
	<alpine.LRH.2.00.1404232338200.1491@twin.jikos.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 23:39:43 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 23 Apr 2014, Andrew Morton wrote:
> 
> > > Echoing values into /proc/sysrq-trigger seems to be a popular way to
> > > get information out of the kernel. However, dumping information about
> > > thousands of processes, or hundreds of CPUs to serial console can
> > > result in IRQs being blocked for minutes, resulting in various kinds
> > > of cascade failures.
> > > 
> > > The most common failure is due to interrupts being blocked for a very
> > > long time. This can lead to things like failed IO requests, and other
> > > things the system cannot easily recover from.
> > 
> > I bet nobody wants that console output anyway.  You do the sysrq then
> > run dmesg or look in /var/log/messages to see what happened.  People
> > who are experiencing problems such as this should run `dmesg -n 1'
> > before writing to sysrq-trigger.
> 
> I don't agree. I have used sysrq-t multiple times in situations where 
> userspace was already dead, but sysrq was still able to provide valuable 
> information about the state of the kernel.
> 

I'm talking about /proc/sysrq-trigger, not the magic key combo.

