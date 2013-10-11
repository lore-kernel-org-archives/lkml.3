Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3JKJHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:07:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:44025 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab3JKJHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:07:04 -0400
Message-ID: <1381482400.5630.79.camel@pasglop>
Subject: Re: sysfs for my chips
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 11 Oct 2013 20:06:40 +1100
In-Reply-To: <CAMuHMdU_90EhPng0NYPVmWAwDt2NOowB3thPB+jJarme-A7eew@mail.gmail.com>
References: <1381378788.4330.30.camel@pasglop>
	 <20131010174457.GE13759@kroah.com> <1381435276.5630.6.camel@pasglop>
	 <CAMuHMdW7RXjS3vvLUdTPCafNu_PcgDgbVbzVCHTOEeTsfHK90g@mail.gmail.com>
	 <1381440651.5630.31.camel@pasglop>
	 <CAMuHMdU_90EhPng0NYPVmWAwDt2NOowB3thPB+jJarme-A7eew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 08:52 +0200, Geert Uytterhoeven wrote:
> > Not sure what you mean .... create a linux bus type with devices on
> > it ?
> 
> Yes, that's what I meant.
> 
> >From the nodes on that bus you can have symlinks in sysfs to e.g. the CPUs
> in the rest of the sysfs tree.
> 
> It's a bit like smbus/i2c connecting various peripherals that may also be
> connected in some other way (e.g. media devices).

It's fairly overkill though ... we don't really plan to expose much of
these things to Linux anyway, it's mostly buried in firmware, I just
want scom access to userspace for debug/diagnostics.

I don't want it in debugfs however because we might want some "health
monitoring" daemon running in userspace that uses it to check some of
the built-in CE statistics etc... in the various chips and handle some
of the repair work. I prefer having that stuff in userspace (it's fairly
complex) than in firmware but it will get all the data it needs from the
device-tree, there's no point trying to reproduce the whole chip
hierarchy and sub hierarchy in Linux.

Cheers,
Ben.


