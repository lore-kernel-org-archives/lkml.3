Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3GPH4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:56:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3GPH4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:56:04 -0400
Date: Tue, 16 Jul 2013 00:56:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-Id: <20130716005611.e4ccab02.akpm@linux-foundation.org>
In-Reply-To: <20130716004727.b60b2c96.akpm@linux-foundation.org>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
	<1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
	<20130712075602.GA4002@gmail.com>
	<20130715150342.35f7620ffe0835e3e2bc37d0@linux-foundation.org>
	<51E472D4.5060307@zytor.com>
	<20130716004727.b60b2c96.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 00:47:27 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 15 Jul 2013 15:08:20 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 07/15/2013 03:03 PM, Andrew Morton wrote:
> > > 
> > > I don't know how to do this.  Any suggestions?
> > > 
> > > It has to be done at `make config' time.  We'd need to probe for the
> > > presence of lz4c and then....  what?
> > > 
> > > Is there any precedent for this?
> > > 
> > > I don't think we can just ignore the absence of lz4c - the user has
> > > selected a config which his system cannot build.  The problem lies
> > > within randconfig itself.
> > > 
> > 
> > We keep running over the need to be able to have kconfig run tests on
> > the build system (for toolchain support or for optional tools needed);
> > running them in the Makefiles (i.e. at Kbuild time) is simply too late.
> > 
> 
> Would it make sense to extend Kconfig's `depends'?
> 
> 	depends on $(shell-command)
> 
> I don't know how practical that would be to implement...

Or, easier and faster, run some front-end script which generates
once-off Kconfig symbols.

	if [ -x /bin/lz4c ]
	then
		echo CONFIG_HAVE_LZ4C
	fi

then munge the output of that script into the Kconfig run and do

	depends on HAVE_LZ4C
