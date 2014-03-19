Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaCSTup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:50:45 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63504 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaCSTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140314223150.0b49723e@alan.etchedpixels.co.uk>
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
	<20140314223150.0b49723e@alan.etchedpixels.co.uk>
Date: Wed, 19 Mar 2014 12:50:41 -0700
X-Google-Sender-Auth: O_kPZl8w9R8aRYAKOxQI4z7N_kY
Message-ID: <CAGXu5jKBtVhg6tYYDyQHcmrmOa1JduGkp6YgXvQeqm3CMEnc1w@mail.gmail.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
From: Kees Cook <keescook@chromium.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 3:31 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Fri, 14 Mar 2014 22:15:45 +0000
> Matthew Garrett <matthew.garrett@nebula.com> wrote:
>
>> On Fri, 2014-03-14 at 22:08 +0000, One Thousand Gnomes wrote:
>> > On Fri, 14 Mar 2014 21:56:33 +0000
>> > Matthew Garrett <matthew.garrett@nebula.com> wrote:
>> > > Signed userspace is not a requirement, and therefore any solution that
>> > > relies on a signed initrd is inadequate. There are use cases that
>> > > require verification of the initrd and other levels. This isn't one of
>> > > them.
>> >
>> > The job of the kernel is to solve the general problem. There are lots of
>> > people who happen to care about verification beyond the kernel so it
>> > shouldn't be ignored. And they can do do things like load trusted SELinux
>> > rulesets even if you can't support it in your environment.
>>
>> The general problem includes having to support this even without an
>> selinux policy.
>
> Yes. No dispute about that. But equally the general solution should allow
> for it.
>
>> And one that's not going to change, so the general problem includes not
>> relying on a signed initramfs.
>
> Likewise
>
>> some other way. ChromeOS will load unmeasured kernel modules provided it
>> can attest to the trustworthyness of the filesystem containing them.
>
> See "How to Bypass Verified Boot Security in Chromium OS" 8)

That method a) is intentionally available (system owner can disable
firmware RO and install their own keys), and b) requires physical
presence.

> So ChromeOS loads *measured* kernel modules. It just did the measuring
> differently to the signed module code.

Right, using dm-verity. However, the read-only media case is still
valid (and is why I am still trying to get the module restrictions LSM
accepted, and why I'm modelling my firmware restrictions on the same
principle).

-Kees

-- 
Kees Cook
Chrome OS Security
