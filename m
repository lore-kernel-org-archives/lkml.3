Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaIEAkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:40:22 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:37957 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaIEAkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:40:21 -0400
Message-ID: <1409876991.28990.172.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, akpm@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 04 Sep 2014 18:29:51 -0600
In-Reply-To: <CALCETrWxKFtM8FhnHQz--uaHYbiqShE1XLJxMCKN7Rs4SO14eQ@mail.gmail.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
	 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
	 <20140904201123.GA9116@khazad-dum.debian.net> <5408C9C4.1010705@zytor.com>
	 <20140904231923.GA15320@khazad-dum.debian.net>
	 <CALCETrWxKFtM8FhnHQz--uaHYbiqShE1XLJxMCKN7Rs4SO14eQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 16:34 -0700, Andy Lutomirski wrote:
> On Thu, Sep 4, 2014 at 4:19 PM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Thu, 04 Sep 2014, H. Peter Anvin wrote:
> >> On 09/04/2014 01:11 PM, Henrique de Moraes Holschuh wrote:
> >> > I am worried of uncharted territory, here.  I'd actually advocate for not
> >> > enabling the upper four PAT entries on IA-32 at all, unless Windows 9X / XP
> >> > is using them as well.  Is this a real concern, or am I being overly
> >> > cautious?
> >>
> >> It is extremely unlikely that we'd have PAT issues in 32-bit mode and
> >> not in 64-bit mode on the same CPU.
> >
> > Sure, but is it really a good idea to enable this on the *old* non-64-bit
> > capable processors (note: I don't mean x86-64 processors operating in 32-bit
> > mode) ?
> >
> >> As far as I know, the current blacklist rule is very conservative due to
> >> lack of testing more than anything else.
> >
> > I was told that much in 2009 when I asked why cpuid 0x6d8 was blacklisted
> > from using PAT :-)
> 
> At the very least, anyone who plugs an NV-DIMM into a 32-bit machine
> is nuts, and not just because I'd be somewhat amazed if it even
> physically fits into the slot. :)

According to the spec, the upper four entries bug was fixed in Pentium 4
model 0x1.  So, the remaining Intel 32-bit processors that may enable
the upper four entries are Pentium 4 model 0x1-4.  Should we disable it
for all Pentium 4 models?

Thanks,
-Toshi  

