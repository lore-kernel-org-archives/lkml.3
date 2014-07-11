Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaGKHjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:39:09 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37234 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGKHjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:39:06 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
Date: Fri, 11 Jul 2014 09:38:56 +0200
Message-ID: <3524198.dm6HbYTJqK@calvin>
User-Agent: KMail/4.13.2 (Linux/3.15.5; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140710200527.GA15190@google.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com> <CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com> <20140710200527.GA15190@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data giovedì 10 luglio 2014 14:05:27, Bjorn Helgaas ha scritto:
> On Thu, Jul 10, 2014 at 09:12:44PM +0200, Stephane Eranian wrote:
> > On Thu, Jul 10, 2014 at 2:13 PM, Fabio Coatti <fabio.coatti@gmail.com> 
wrote:
> > > In data giovedì 10 luglio 2014 10:54:48, Peter Zijlstra ha scritto:
> > >> On Thu, Jul 10, 2014 at 10:52:08AM +0200, Peter Zijlstra wrote:
> > >> > On Thu, Jul 10, 2014 at 10:44:21AM +0200, Peter Zijlstra wrote:
> > >> > > On Wed, Jul 09, 2014 at 12:48:05PM -0700, Fabio Coatti wrote:
> > >> > > > In data mercoledì 9 luglio 2014 11:54:21, Greg Kroah-Hartman ha
> > > 
> > > scritto:
> > >> > > > > Try cc:ing everyone on that patch, with the original
> > >> > > > > information you
> > >> > > > > provided, and the linux-kernel mailing list.  Those developers
> > >> > > > > should be
> > >> > > > > able to help you out properly.
> > >> > > > 
> > >> > > > Ok, here you can find the description of a problem that I'm
> > >> > > > experiencing on
> > >> > > > latest kernels, since 3.15.0.  (this report comes from 3.15.4)
> > >> > > > 
> > >> > > > lug 07 22:08:00 calvin kernel: resource map sanity check
> > >> > > > conflict:
> > >> > > > 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff reserved
> > >> > > > lug 07 22:08:00 calvin kernel: ------------[ cut here
> > >> > > > ]------------
> > >> > > 
> > >> > > I think this is a 'known' issue on Thinkpad (iirc). For some
> > >> > > obscure
> > >> > > reason its BIOS has funny ideas about resources etc.
> > >> > > 
> > >> > > I couldn't quickly find the prvious thread, maybe Stephane knows.
> > >> > 
> > >> > Found it:
> > >> >   lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
> > >> 
> > >> Ok, reread that thread and no definite conclusion was found I think.
> > >> Just Thinkpad firmware having overlapping resources.
> > > 
> > > So I guess that this happens also for HP Folio 9470m, not only in
> > > thinkpads. I wonder how many machines shares this behaviour...
> > 
> > Somehow, I thought that Bjorn had proposed a fix for this.
> 
> Yep, this [1]:
> 
>     cb171f7abb9a PNP: Work around BIOS defects in Intel MCH area reporting
> 
> which appeared in v3.15, so it should be in your kernel.  But apparently
> it didn't work.  Fabio, can you pastebin your complete dmesg log?
> 
> [1]
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c
> b171f7abb9a

Sure, here you go:

http://pastebin.com/FiL7N64b


-- 
Fabio
