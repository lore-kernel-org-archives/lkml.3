Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629Ab3LIVvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:51:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab3LIVvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:51:21 -0500
Date: Mon, 9 Dec 2013 22:51:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
In-Reply-To: <CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312092250010.24835@pobox.suse.cz>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com> <alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz> <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com> <alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
 <CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, H.J. Lu wrote:

> >> No, please don't do that.  Normally, PIE has zero load address and kernel
> >> can load it anywhere.  There are multiple reasons why PIE has non-zero
> >> load address.  Saying you need to load a program above 4GB under x86-64,
> >> you can't do that with normal dynamic executable.  PIE with non-zero load
> >> address is the only way to do that on x86-64.
> >
> > Hmm, so if it's because of 4G PT_LOAD limit, how about at least adding
> 
> Yes.
> 
> > randomized offset to the supplied vaddr?
> 
> Yes, people who build PIE with non-zero vaddr can use
>  randomized vaddr. 

I don't follow you here. Do you suggest compile-time randomzation?

> > PT_LOAD being non-zero causing randomization to be turned off seems like
> > quite unexpected behavior to me, with a great potential to cause a lot of
> > confusion.
> >
> 
> There should be no difference between dynamic executable and PIE
> with non-zero vaddr when choosing where to load them.

Could you please elaborate why do you think this statement is true?

Thanks,

-- 
Jiri Kosina
SUSE Labs
