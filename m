Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaCNVs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:48:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaCNVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:48:25 -0400
Date: Fri, 14 Mar 2014 21:48:06 +0000
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
Message-ID: <20140314214806.54a3d031@alan.etchedpixels.co.uk>
In-Reply-To: <1394820664.26846.18.camel@x230.mview.int.nebula.com>
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
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a set of patches that appear acceptable to the security
> maintainer. I've rewritten them multiple times in response to various
> levels of bikeshedding. They solve a real problem and are being shipped
> by multiple distributions.

And ? I've seen some of the other "extra" stuff distributions ship. Lots
of it is hilariously bad. That really isn't a good argument for the code
- for the feature yes.

> What the rest of your mail is asking me to do is to rewrite capabilities
> support entirely. Now, yes, I agree that capabilities are an awful
> interface that's approximately impossible to use correctly and which
> adds little security even if you do. But I reject the idea that
> rewriting fundamental security infrastructure should be a prerequisite
> for adding this functionality.

Actually it's nothing of the sort. It's a proposal to do it. It's 90% a
regexp task. I'm offering to go and do that bit. I am quite happy
to do the capability crapfest fixing. It wants doing *anyway*.

But if I got do that work, does it solve your problem ? I think it does
but I'd like to be sure.

> > > It needs to be possible for this policy to be imposed without userspace
> > > being involved, so using selinux would mean baking it into the kernel
> > > (along with an additional implementation for apparmor, and presumably
> > > one for tomoyo as well).
> > 
> > That's clearly false. You can load signed modules so you can load signed
> > policies. Assuming you don't have an initial measured file system you
> > need a kernel policy initially that protects you. If you have a measured
> > file system you don't even need that, nor do you need to revoke RAWIO in
> > kernel, you can do it before you switch into "measured and running
> > un-measured code" mode - ie about the point you pivot root out of the
> > initrd that loaded the measured policy.
> 
> We can't rely on userspace choosing to load that policy. We don't have a
> measured filesystem. The initrd is not signed (and nor can it be). The
> kernel itself *must* impose policy.

In your particularly implementation maybe you've got a weak setup where
you don't measure down to your initrd. That's a *flaw* in your
implementation. Don't inflict your limitations on others or on the
future. EFI is only one (and not a very strong one at that) implementation
of a 'secure' boot chain. A lot of other systems can not only propogate
measurement and security assertions into their initrd they can propogate
them into their rootfs (yes upgrades are .. exciting, but these kinds of
users will live with that pain).

Even in EFI you can make your kernel or loader check the initrd signature
and the rootfs signature if you want.

> Sure! Except then A Large Vendor's custom IPMI userspace stops working,
> even on systems without Secure Boot, and then said Large Vendor wants to
> have conference calls at times that are convenient for Japan and then
> this is an issue that's going to cause $1 billion in lost sales and come
> on, you've been there. You know that this isn't going to work. 

That's not an upstream problem (but with my work hat on I understand
your position). Anyway they'll be running someones enterprise product
which will have legacy enabled out of the wazoo so their customers 15 year
old "we lost the code" blob that nobody can even remember what it does
still works 8)

> > If we are going to do a measured kernel then it needs to be done right,
> > it needs to be properly abstracted so we don't add another one for
> > Android, another one for Chrome, another one for ARM trustzone, another
> > one for Intel SGX, and so on.
> 
> The fact that you keep saying measured really does make me suspect that
> you misunderstand the problem. There's no measurement involved, there's
> simply an assertion that the firmware (which you're forced to trust)
> chose, via some policy you may be unaware of, to trust the booted
> kernel.

You are currently using some of those interfaces for measuring to produce
a notionally 'trusted' initial loaded environment.

Correct me if I am wrong but your starting point is "I have a chain of
measurement as far as the kernel I load". Without that I can just go into
grub and 0wn you.

There are multiple things you want to do in measured environments,
stopping people sneakily loading new kernels is one of them. If you want
to talk about "secure" that implies a whole load more than ring 0 hacks.
It implies having a model where not only has J Random smart hacker gone
over the code and hacked all the call points, but that someone has done
some kind of formal review of it, used good security practices like
whitelisting and thought very hard about the rest of the exposed surfaces.

Otherwise its security theatre, it's marketing fluff. We've got lots of
marketing security fluff in the kernel, we don't need more of it.

Alan
