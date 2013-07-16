Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3GPJZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:25:20 -0400
Received: from p-mail2.rd.orange.com ([195.101.245.16]:26310 "EHLO
	p-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3GPJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:25:18 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new streaming format
Date: Tue, 16 Jul 2013 11:25:14 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.10-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com,
        Andy Lee <raphael.andy.lee@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <20130716005611.e4ccab02.akpm@linux-foundation.org> <CAGVrzcaTMckMKUObknT8abPyOzetuHzWtNPkF=Ae4zz7huShkQ@mail.gmail.com>
In-Reply-To: <CAGVrzcaTMckMKUObknT8abPyOzetuHzWtNPkF=Ae4zz7huShkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307161125.14491.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Jul 2013 09:25:14.0837 (UTC) FILETIME=[60F47050:01CE8206]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian, All,

On Tuesday 16 July 2013 11:13:24 Florian Fainelli wrote:
> 2013/7/16 Andrew Morton <akpm@linux-foundation.org>:
> > On Tue, 16 Jul 2013 00:47:27 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> On Mon, 15 Jul 2013 15:08:20 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> >>
> >> > On 07/15/2013 03:03 PM, Andrew Morton wrote:
> >> > >
> >> > > I don't know how to do this.  Any suggestions?
> >> > >
> >> > > It has to be done at `make config' time.  We'd need to probe for the
> >> > > presence of lz4c and then....  what?
> >> > >
> >> > > Is there any precedent for this?
> >> > >
> >> > > I don't think we can just ignore the absence of lz4c - the user has
> >> > > selected a config which his system cannot build.  The problem lies
> >> > > within randconfig itself.
> >> > >
> >> >
> >> > We keep running over the need to be able to have kconfig run tests on
> >> > the build system (for toolchain support or for optional tools needed);
> >> > running them in the Makefiles (i.e. at Kbuild time) is simply too late.
> >> >
> >>
> >> Would it make sense to extend Kconfig's `depends'?
> >>
> >>       depends on $(shell-command)
> >>
> >> I don't know how practical that would be to implement...
> >
> > Or, easier and faster, run some front-end script which generates
> > once-off Kconfig symbols.
> >
> >         if [ -x /bin/lz4c ]
> >         then
> >                 echo CONFIG_HAVE_LZ4C
> >         fi
> >
> > then munge the output of that script into the Kconfig run and do
> >
> >         depends on HAVE_LZ4C
> 
> That does sound nice to avoid the build error, but will eventually
> make it harder to diagnose why the kernel has not been compressed with
> the specific compression tool, some kind of warning should also be
> emitted maybe?

Either a warning at check-time, or a comment in Kconfig, such as:
    config COMPRESS_LZ4
        depends on HAVE_LZ4
    comment "'lz4' missing, LZ4 compression not available"
        depends on !HAVE_LZ4

Either way is fine with me. ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
