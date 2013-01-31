Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3AaLSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:18:33 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40413 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3AaLSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:18:30 -0500
Date: Thu, 31 Jan 2013 12:18:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Mike Lykov <combr@yandex.ru>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
Message-ID: <20130131111823.GA4587@gmail.com>
References: <5107D1D3.6040105@yandex.ru>
 <20130129153348.GR98867@redhat.com>
 <20130129155917.4ee64214.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129155917.4ee64214.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 29 Jan 2013 10:33:48 -0500
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -79,6 +79,14 @@ static int __init softlockup_panic_setup(char *str)
> >  }
> >  __setup("softlockup_panic=", softlockup_panic_setup);
> >  
> > +static int __init watchdog_thresh_setup(char *str)
> > +{
> > +	watchdog_thresh = simple_strtoul(str, NULL, 0);
> > +
> > +	return 1;
> > +}
> > +__setup("watchdog_thresh=", watchdog_thresh_setup);
> 
> I wonder if there's some magical way in which we can set any 
> sysctl from the kernel command line.  Add 
> sys.vm.min_free_kbytes=42 to the command line, walk the 
> hierarchy late in boot...

A facility like that would be totally awesome - we could remove 
a lot of duplicated and outright inconsistent (often missing) 
__setup() hackery that way.

Single source of information and all that.

Thanks,

	Ingo
