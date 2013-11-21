Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3KUKCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:02:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3KUKCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:02:22 -0500
Date: Thu, 21 Nov 2013 11:02:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall
In-Reply-To: <20131119201632.GG29695@two.firstfloor.org>
Message-ID: <alpine.LRH.2.00.1311211059260.9932@twin.jikos.cz>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org> <528ACDB2.9040806@amacapital.net> <20131119201632.GG29695@two.firstfloor.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, Andi Kleen wrote:

> > > +	err = get_user_pages_fast((unsigned long)addr, npages, 1, pages);
> > > +	if (err < 0)
> > > +		return err;
> > > +	err = 0;
> > > +	mutex_lock(&text_mutex);
> > > +	bp_target_mm = current->mm;
> > > +	bp_int3_addr = (u8 *)addr + 1;
> > 
> > Do you need an smp_wmb here?  (Maybe there's a strong enough barrier in
> > __text_poke_bp.)
> 
> __text_poke_bp already has enough barriers (although I don't
> think they are really needed in any case)

As an author of those barriers I have to ask -- why do you think so? The 
first one is there to avoid int3 handler seeing !patching_in_progress 
while it has actually been entered due to text_poke_bp() kicking in.

The second one is there for exactly the inverse reason.

Both are pairing to smp_rmb() in poke_int3_handler().

Thanks,

-- 
Jiri Kosina
SUSE Labs

