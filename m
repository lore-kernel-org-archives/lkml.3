Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3KSUQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:16:35 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55077 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KSUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:16:34 -0500
Date: Tue, 19 Nov 2013 21:16:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131119201632.GG29695@two.firstfloor.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <528ACDB2.9040806@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528ACDB2.9040806@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	pages[1] = NULL;
> > +	npages = ((unsigned long)addr & PAGE_MASK) == 
> > +		(((unsigned long)addr + len) & PAGE_MASK) ? 1 : 2;
> 
> This is off by one, I think.  That should be addr + len - 1.

Thanks fixed.

> 
> > +	err = get_user_pages_fast((unsigned long)addr, npages, 1, pages);
> > +	if (err < 0)
> > +		return err;
> > +	err = 0;
> > +	mutex_lock(&text_mutex);
> > +	bp_target_mm = current->mm;
> > +	bp_int3_addr = (u8 *)addr + 1;
> 
> Do you need an smp_wmb here?  (Maybe there's a strong enough barrier in
> __text_poke_bp.)

__text_poke_bp already has enough barriers (although I don't
think they are really needed in any case)

-Andi
