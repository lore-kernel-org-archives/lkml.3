Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaCNXSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:18:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:41569 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbaCNXSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:18:48 -0400
Date: Fri, 14 Mar 2014 19:18:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Message-ID: <20140314231832.GA653@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jmorris@namei.org" <jmorris@namei.org>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
	"linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
References: <1394746248.27846.3.camel@x230>
 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
 <1394762250.6416.24.camel@x230.lan>
 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
 <1394801518.6416.38.camel@x230.lan>
 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
 <1394834193.1286.11.camel@x230>
 <20140314220840.29a12171@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314220840.29a12171@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:08:40PM +0000, One Thousand Gnomes wrote:
> > Signed userspace is not a requirement, and therefore any solution that
> > relies on a signed initrd is inadequate. There are use cases that
> > require verification of the initrd and other levels. This isn't one of
> > them.
> 
> The job of the kernel is to solve the general problem. There are lots of
> people who happen to care about verification beyond the kernel so it
> shouldn't be ignored. And they can do do things like load trusted SELinux
> rulesets even if you can't support it in your environment.

This is really a question about goals and trust models.  Alan is
arguing that we should support trust models and goals which go far
beyond the goals and trust model of the UEFI Forum.

Matthew is, I think, trying to make the argument that his patches
fulfill the goals that are needed so we can boot Linux distribution
kernels on UEFI secure boot machines without worrying about Microsoft
deciding to revoke keys so that Red Hat or SuSE will no longer be able
to be bootable on desktops that are certified for Windows 8.  And
while we might want to improve the framework to support other trust
models later on, supporting distro kernels on Windows 8 certified PC's
is important enough that we should let these patches into mainline.

Is that a fair summary of the two viewpoints?

Personally, I think that we are fortunate that Windows 8 has been
enough of a train wreck that huge numbers of users have been taking
Windows 8 systems and upgrading them to Windows 7, and hence the need
for Distro kernels that can boot on fully locked down Windows 8 PC's.
But at some point, whether it is a few years or a decade later (if
Windows 7 lives on as long as XP :-), Windows 7 will be EOL'ed, and
even before that, UEFI secure boot will be enabled by default.

Right now, even though Lenovo laptops are shipping with Windows
8. UEFI secure boot is not made mandatory (although it is on enough to
brick the laptop when it runs into bugs wwith the UEFI BIOS code,
sigh).  But sooner or later, UEFI secure boot will be on by default,
and then if Linux distros don't have kernels where the installer can
be run without needing to twiddle BIOS settings, it might make it
harder for the "Year of the Desktop" to come about.

So as far as the narrow question of whether we should accept these
patches, I think it's a good thing.  Personally, I'm always going to
be disabling UEFI secure boot (even if it doesn't brick my laptop),
because for me, the security guarantees it provides isn't worth it.
But there will be people who want to be able to install Linux on
Windows 8 certified PC's without tweaking BIOS settings, so merging
the UEFI secure boot is a good thing, so long as those of use who
don't want to have anything to do with UEFI secure boot can disable
it.

Regards,

					- Ted
