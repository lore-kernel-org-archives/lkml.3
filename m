Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaIZIAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:00:18 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:44559 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbaIZIAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:00:16 -0400
Date: Fri, 26 Sep 2014 10:59:00 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux <linux@openrisc.net>,
        Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: New build failures in Sep 25 tree
Message-ID: <20140926075859.GA21697@chokladfabriken.org>
References: <20140925202559.GA1750@roeck-us.net>
 <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 08:30:57AM +0200, Geert Uytterhoeven wrote:
> Hi Günther,
> 
> [cc openrisc]
> 
> On Thu, Sep 25, 2014 at 10:25 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > New build failures:
> 
> > openrisc-defconfig
> >
> > In file included from arch/openrisc/kernel/signal.c:31:0:
> > ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> > ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
> 
> That's not a new one. It's been failing for half or year or so.
> 
> If you only see it now, that means something else got fixed ;-)
> 

>From what I can see, it's caused by
ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
that got (re?)introduced two days ago.

To me it seems that the problem is that EM_OPENRISC is
missing in include/uapi/linux/elf-em.h, but if that's the case,
I think microblaze have the same problem with that patch applied.

Stefan
