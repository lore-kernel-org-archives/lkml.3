Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaCNWcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:32:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37059 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbaCNWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:32:06 -0400
Date: Fri, 14 Mar 2014 22:31:50 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140314223150.0b49723e@alan.etchedpixels.co.uk>
In-Reply-To: <1394835345.1286.22.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
	<20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	<1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<1394835345.1286.22.camel@x230>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 22:15:45 +0000
Matthew Garrett <matthew.garrett@nebula.com> wrote:

> On Fri, 2014-03-14 at 22:08 +0000, One Thousand Gnomes wrote:
> > On Fri, 14 Mar 2014 21:56:33 +0000
> > Matthew Garrett <matthew.garrett@nebula.com> wrote:
> > > Signed userspace is not a requirement, and therefore any solution that
> > > relies on a signed initrd is inadequate. There are use cases that
> > > require verification of the initrd and other levels. This isn't one of
> > > them.
> > 
> > The job of the kernel is to solve the general problem. There are lots of
> > people who happen to care about verification beyond the kernel so it
> > shouldn't be ignored. And they can do do things like load trusted SELinux
> > rulesets even if you can't support it in your environment.
> 
> The general problem includes having to support this even without an
> selinux policy.

Yes. No dispute about that. But equally the general solution should allow
for it.

> And one that's not going to change, so the general problem includes not
> relying on a signed initramfs.

Likewise

> some other way. ChromeOS will load unmeasured kernel modules provided it
> can attest to the trustworthyness of the filesystem containing them.

See "How to Bypass Verified Boot Security in Chromium OS" 8)

And it attests the trustworthiness of the filesystem by measuring it. If
you have a measurement of object X that states it is unchanged then you
have a valid measurement of any subset of object X for which the same
assertion is proven. In this case since you know all the bits in the root
fs are as before, so you know all the bits in the module are as before

And how do you know all the bits in the root fs are as before, because you
have a set of measurements (hashes) on partition 12. At the end of the
day you end up with a chain of measurements from a trusted thing you deep
immutable. If your chain has gaps you have holes (see above).

So ChromeOS loads *measured* kernel modules. It just did the measuring
differently to the signed module code.

Alan


 
