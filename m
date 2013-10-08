Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3JHMkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:40:18 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:50390 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3JHMkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:40:16 -0400
Date: Tue, 8 Oct 2013 08:40:14 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, gthelen@google.com
Message-ID: <1745634600.2780529.1381236014344.JavaMail.root@redhat.com>
In-Reply-To: <20131008080604.GA4820@localhost>
References: <CAOMFOmWbvLCM=a2n_ojnWVeeyvMg=v1T03Q44q-q4jgR7sH+DA@mail.gmail.com> <20131008080604.GA4820@localhost>
Subject: Re: mm: Export 'pageflag_names' array
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF22 (Linux)/8.0.3_GA_5664)
Thread-Topic: Export 'pageflag_names' array
Thread-Index: K0pO6gKrxmEV7bBH8UjtsLc/RiOTQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> Hi Anatol,
> 
> On Mon, Oct 07, 2013 at 10:53:32AM -0700, Anatol Pomozov wrote:
> > Hi Wu
> > 
> > I have a request wrt your old commit 718a38211.
> > 
> > I think it makes sense to export array pageflag_names so kernel dump
> > debug tools (like 'crash') can use it as well. Currently the tool
> > hard-codes flag names but it is suboptimal as flags are different for
> > different configs.
> > 
> > What do you think? (I can send a patch if you are ok).
> 
> I wonder if the KPF_* defined in
> 
>         include/uapi/linux/kernel-page-flags.h
> 
> fit your needs. These are kernel page flags exported to the user space
> and will be maintained stable and immune to kconfig changes. You can
> find use examples of them in
> 
>         fs/proc/page.c
>         tools/vm/page-types.c
> 
> Thanks,
> Fengguang
> 

Nothing is required for the crash utility.  The pageflag_names array (as well
as the pageflags enumerator) are readily available in the kernel debuginfo
data.

Dave
  
