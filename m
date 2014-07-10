Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaGJUFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:05:32 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:40233 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaGJUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:05:30 -0400
Date: Thu, 10 Jul 2014 14:05:27 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Stephane Eranian <eranian@google.com>
Cc: Fabio Coatti <fabio.coatti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171
 __ioremap_caller+0x290/0x2fa()
Message-ID: <20140710200527.GA15190@google.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
 <20140710085208.GD12054@laptop.lan>
 <20140710085448.GE12054@laptop.lan>
 <2093681.h3dgJ8rFNA@calvin>
 <CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:12:44PM +0200, Stephane Eranian wrote:
> On Thu, Jul 10, 2014 at 2:13 PM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> > In data giovedì 10 luglio 2014 10:54:48, Peter Zijlstra ha scritto:
> >> On Thu, Jul 10, 2014 at 10:52:08AM +0200, Peter Zijlstra wrote:
> >> > On Thu, Jul 10, 2014 at 10:44:21AM +0200, Peter Zijlstra wrote:
> >> > > On Wed, Jul 09, 2014 at 12:48:05PM -0700, Fabio Coatti wrote:
> >> > > > In data mercoledì 9 luglio 2014 11:54:21, Greg Kroah-Hartman ha
> > scritto:
> >> > > > > Try cc:ing everyone on that patch, with the original information you
> >> > > > > provided, and the linux-kernel mailing list.  Those developers
> >> > > > > should be
> >> > > > > able to help you out properly.
> >> > > >
> >> > > > Ok, here you can find the description of a problem that I'm
> >> > > > experiencing on
> >> > > > latest kernels, since 3.15.0.  (this report comes from 3.15.4)
> >> > > >
> >> > > > lug 07 22:08:00 calvin kernel: resource map sanity check conflict:
> >> > > > 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff reserved
> >> > > > lug 07 22:08:00 calvin kernel: ------------[ cut here ]------------
> >> > >
> >> > > I think this is a 'known' issue on Thinkpad (iirc). For some obscure
> >> > > reason its BIOS has funny ideas about resources etc.
> >> > >
> >> > > I couldn't quickly find the prvious thread, maybe Stephane knows.
> >> >
> >> > Found it:
> >> >   lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
> >>
> >> Ok, reread that thread and no definite conclusion was found I think.
> >> Just Thinkpad firmware having overlapping resources.
> >
> >
> > So I guess that this happens also for HP Folio 9470m, not only in thinkpads. I
> > wonder how many machines shares this behaviour...
> >
> Somehow, I thought that Bjorn had proposed a fix for this.

Yep, this [1]:

    cb171f7abb9a PNP: Work around BIOS defects in Intel MCH area reporting

which appeared in v3.15, so it should be in your kernel.  But apparently
it didn't work.  Fabio, can you pastebin your complete dmesg log?

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=cb171f7abb9a
