Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3LKNgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:36:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3LKNgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:36:38 -0500
Date: Wed, 11 Dec 2013 14:36:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
In-Reply-To: <CAMe9rOqAV5_+H97XSnrOHxcruouC=hCjDuEkiiyM8UM0BH5CWw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312111435470.1413@pobox.suse.cz>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com> <alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz> <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com> <alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
 <CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com> <52A63AD4.2030101@zytor.com> <CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com> <52A63BF3.1000608@zytor.com> <CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>
 <52A63DCF.2060504@zytor.com> <CAMe9rOqAV5_+H97XSnrOHxcruouC=hCjDuEkiiyM8UM0BH5CWw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, H.J. Lu wrote:

> >> so that he could load his program compiled as PIE above 4GB.
> >> If kernel is changed not to honor it, his program won't work any more.
> >> In normal case, PIE has zero vaddr and this doesn't apply.
> >>
> >
> > That doesn't seem to be PIE at all, and if it is PIE, then it should be
> > relocatable (I agree btw with randomizing upward from the selected address.)
> 
> Kernel can consider PIE with non-zero vaddr isn't real PIE.

Why?

I still think PIE with non-zero vaddr should be randomized by putting 
random offset to the vaddr. Don't you think so? Why?

-- 
Jiri Kosina
SUSE Labs
