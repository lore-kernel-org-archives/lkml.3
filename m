Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab3BWTnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 14:43:13 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:60794 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab3BWTnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 14:43:09 -0500
Date: Sat, 23 Feb 2013 14:43:01 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/mm changes for v3.9-rc1
Message-ID: <20130223194300.GA13174@konrad-lan.dumpdata.com>
References: <alpine.DEB.2.02.1302221929040.22997@kaball.uk.xensource.com>
 <5127CE65.5010703@linux.intel.com>
 <CAE9FiQXHHFb0W+aJCsefRNj4p+X1+m8JOLUDz74w-nAjnhym+A@mail.gmail.com>
 <5127DDB3.2010309@zytor.com>
 <CAE9FiQWctM60VwXJYtOXwPBNLUoz966Fr1g6MPsPoJBiye88YQ@mail.gmail.com>
 <5127FBA4.1040506@zytor.com>
 <20130223003738.GA23545@phenom.dumpdata.com>
 <CAE9FiQVTbDkvU8KQGVoYv3kn6UeCTcdiPA2hvw21OKtNbM=XKg@mail.gmail.com>
 <20130223012716.GA28377@phenom.dumpdata.com>
 <CAE9FiQUcJiDOjv-XYYUfQAAHaZCq2Q1heR5YakGf13SYJjxyxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUcJiDOjv-XYYUfQAAHaZCq2Q1heR5YakGf13SYJjxyxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> how about if we call load_cr3 early several times?
> >> assume you should make xen_write_cr3 more robust,
> >> like bailing out early when cr3 writing same value.
> >
> > I would welcome such patch - but at this point I just want a
> > patch for Linus so that I am not blocking him - and this
> > one works.
> 
> come on, you produce
> 
>   #ifdef CONFIG_X86_32
>          .write_cr3 = xen_write_cr3_init,
>   #else
>          .write_cr3 = xen_write_cr3_init,
>   #endif
> 
> for the fix, Linus should just apply attached patch instead.

I misunderstood you. I thought you were talking about
"how about if we call .. cr3 writing same value" - and that part
I hadn't thought completly through so I did not want to delay
Linus.

Naturally the fixes you pointed out should be in the patch - and
hpa graciously did the fixes and sent to Linus. Thank you Peter!
> 
> >>
> >> Also you should check condition about calling xen_get_user_pgd().
> >
> > Could you elaborate please?
> 
> only call xen_get_user_pgd() when it should be called.

I should have been more explicit. When I was saying "elaborate" I was
soliciting for advice on the 'check condition' and how to make it robust.
> 
> Yinghai


