Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbbA0NVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:21:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbA0NV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:21:29 -0500
Date: Tue, 27 Jan 2015 14:21:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robherring2@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150127132127.GA869@amd>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201412041857.49341@pali>
 <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
 <201501262016.52079@pali>
 <CAL_JsqL_EEg7tC-q8wV5v8jAfPSiri4z19iJfz2r7zntRwPyOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqL_EEg7tC-q8wV5v8jAfPSiri4z19iJfz2r7zntRwPyOg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-26 14:33:21, Rob Herring wrote:
> On Mon, Jan 26, 2015 at 1:16 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> > This patch will cause that decompressor store full ATAG structure into DT tree ("/atags"):
> >

> > +       /* include the terminating ATAG_NONE */
> > +       atag_size = (char *)atag - (char *)atag_list + sizeof(struct tag_header);
> > +       setprop(fdt, "/", "atags", atag_list, atag_size);
> > +
> >         if (memcount) {
> >                 setprop(fdt, "/memory", "reg", mem_reg_property,
> >                         4 * memcount * memsize);
> >
> >
> >
> > And this patch will export ATAG structure from DT tree ("/atags") into /proc/atags file:
> 
> Please properly send your patches.

Actually, when sending patches for discussion, this is format easier
to read.

> > Some userspace applications needs access to ATAG structure where can be stored some information passed
> > from bootloader to kernel. Example is Nokia N900 device and NOLO bootloader which provides information
> > about bootreason (device was started by power button or by alarm or restarted...) and bootmode (normal
> > mode or device update mode).
> 
> This goes in the commit message.
> 
> These would be non-standard fields which are not upstream. I don't
> know that we care in that case...

Other devices are going to care about boot reason, too, and we might
as well be compatible...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
