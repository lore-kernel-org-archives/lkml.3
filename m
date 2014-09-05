Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaIEPxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:53:23 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:17366 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaIEPxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:53:22 -0400
Message-ID: <1409931772.28990.197.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
From: Toshi Kani <toshi.kani@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        akpm@linuxfoundation.org, Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 05 Sep 2014 09:42:52 -0600
In-Reply-To: <5409D99C.10305@zytor.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
			 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
			 <20140904201123.GA9116@khazad-dum.debian.net>
	 <5408C9C4.1010705@zytor.com>
			 <20140904231923.GA15320@khazad-dum.debian.net>
			 <CALCETrWxKFtM8FhnHQz--uaHYbiqShE1XLJxMCKN7Rs4SO14eQ@mail.gmail.com>
			 <1409876991.28990.172.camel@misato.fc.hp.com>
			 <CALCETrUhbx4hFRAkHfczLkZBYo0E7tRmdFyO7bqPd5e9JEWcMA@mail.gmail.com>
		 <1409925614.28990.184.camel@misato.fc.hp.com> <5409D197.2060900@zytor.com>
	 <1409930574.28990.192.camel@misato.fc.hp.com> <5409D99C.10305@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 08:41 -0700, H. Peter Anvin wrote:
> On 09/05/2014 08:22 AM, Toshi Kani wrote:
> > On Fri, 2014-09-05 at 08:07 -0700, H. Peter Anvin wrote:
> >> On 09/05/2014 07:00 AM, Toshi Kani wrote:
> >>>
> >>> That's a fine idea, but as Ingo also suggested, I am going to disable
> >>> this feature on all Pentium 4 models.  That should give us a safety
> >>> margin.  Using slot 4 has a benefit that it keeps the PAT setup
> >>> consistent with Xen.      
> >>>
> >>
> >> Slot 4 is also the maximally problematic one, because it is the one that
> >> might be incorrectly invoked for the page tables themselves.
> > 
> > Good point.  I wonder if Xen folks feel strongly about keeping the PAT
> > setup consistent with the kernel.  If not, we may choose to use slot 6
> > (or 7).
> > 
> 
> Who cares what the Xen folks "feel strongly about"?  If strong feelings
> were a design criterion Xen support would have been pulled from the
> kernel a long, long time ago.
> 
> The important thing is how to design for the situation that we currently
> have to live with.

I see.  Then, I am going to use slot 7 for WT as suggested by Andy.  I
think it is the safest slot as slot 3 is UC and is not currently used.

Thanks,
-Toshi

