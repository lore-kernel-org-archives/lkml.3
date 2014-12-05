Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaLENa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:30:26 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:47648 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaLENaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:30:23 -0500
Date: Fri, 5 Dec 2014 14:30:12 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hughd@google.com" <hughd@google.com>, "hocko@suse.cz" <hocko@suse.cz>
Subject: Re: [PATCH v1 3/5] mm, uaccess: trigger might_sleep() in
 might_fault() when pagefaults are disabled
Message-ID: <20141205143012.5692acd8@thinkpad-w530>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CA035A5@AcuExch.aculab.com>
References: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
	<1417778289-51567-4-git-send-email-dahi@linux.vnet.ibm.com>
	<20141205114529.GD4213@osiris>
	<20141205124629.2c77290f@thinkpad-w530>
	<063D6719AE5E284EB5DD2968C1650D6D1CA035A5@AcuExch.aculab.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120513-0041-0000-0000-000002604D13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Hildenbrand [...
> > > This should be likely() instead of unlikely(), no?
> > > I'd rather write this
> > >
> > > 	if (pagefault_disabled())
> > >  		return;
> > > 	__might_sleep(file, line, 0);
> > >
> > > and leave the likely stuff completely away.
> > 
> > Makes perfect sense!
> 
> From my experience of getting (an older version of) gcc to emit
> 'correctly' statically predicted branches I found that code that
> looks like (I don't think return/goto make any difference):
> 
> 	If (unlikely(condition)) {
> 		code;
> 	}
> 	more_code;
> 
> is compile with a forwards conditional branch (ie ignoring the unlikely()).
> Similarly 'if () continue' is likely to generate a 'predicted taken'
> backwards conditional branch.
> 
> To get the desired effect you need a non-empty 'else' part, an assembler
> comment will suffice, eg: asm volatile("# comment").
> 
> 	David
> 
> 
> 

Thanks for the hint David!

I'm going to drop that unlikely and simply replace in_atomic() by
pagefault_disabled() - will also keep the change minimal!

David

