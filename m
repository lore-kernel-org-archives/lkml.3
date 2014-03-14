Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaCNWJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:09:02 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37033 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaCNWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:08:58 -0400
Date: Fri, 14 Mar 2014 22:08:40 +0000
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
Message-ID: <20140314220840.29a12171@alan.etchedpixels.co.uk>
In-Reply-To: <1394834193.1286.11.camel@x230>
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
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 21:56:33 +0000
Matthew Garrett <matthew.garrett@nebula.com> wrote:

> On Fri, 2014-03-14 at 21:48 +0000, One Thousand Gnomes wrote:
> 
> > In your particularly implementation maybe you've got a weak setup where
> > you don't measure down to your initrd. That's a *flaw* in your
> > implementation. Don't inflict your limitations on others or on the
> > future. EFI is only one (and not a very strong one at that) implementation
> > of a 'secure' boot chain. A lot of other systems can not only propogate
> > measurement and security assertions into their initrd they can propogate
> > them into their rootfs (yes upgrades are .. exciting, but these kinds of
> > users will live with that pain).
> 
> Signed userspace is not a requirement, and therefore any solution that
> relies on a signed initrd is inadequate. There are use cases that
> require verification of the initrd and other levels. This isn't one of
> them.

The job of the kernel is to solve the general problem. There are lots of
people who happen to care about verification beyond the kernel so it
shouldn't be ignored. And they can do do things like load trusted SELinux
rulesets even if you can't support it in your environment.

> > Even in EFI you can make your kernel or loader check the initrd signature
> > and the rootfs signature if you want.
> 
> Except the initramfs gets built at kernel install time.

Implementation detail for your use case.

> > Correct me if I am wrong but your starting point is "I have a chain of
> > measurement as far as the kernel I load". Without that I can just go into
> > grub and 0wn you.
> 
> In my use case. But not all implementations will be measuring things -
> they can assert that the kernel is trustworthy through some other
> mechanism. This genuinely is about trust, not measurement.

The assertion you attempt to achieve is I believe

"No ring 0 code is executed directly or indirectly that is not measured"

Some of your measuring is EFI boot, some is module signing and then you
must impose a security model as well.

It's a "measurement" problem if you ask what the rule is - yes ? Getting
there is not just a measurement problem but your intended result is a
measurement based rule ?

Alan



