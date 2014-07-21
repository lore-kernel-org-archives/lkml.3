Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbaGURnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:43:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbaGURnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:43:19 -0400
Date: Mon, 21 Jul 2014 10:43:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <kees@outflux.net>, Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] firmware_class: add "fd" input file
Message-ID: <20140721174318.GA15788@kroah.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-7-git-send-email-keescook@chromium.org>
 <CACVXFVOnxjXjnKRWg7sv425POLSS96kAxxEohtLqj4dvcxnRyg@mail.gmail.com>
 <CAGXu5j+xx2exZdD64mXWzmvVUzBrFUOg-kZ5E4+tvKAuGTKW4w@mail.gmail.com>
 <CACVXFVMk5hTAvMgL0V2ycy-P=LCtOktimw5Hst+aFYLS6jewXw@mail.gmail.com>
 <CAGXu5jLD=9cqzV90JKEBJjwzTXVzGhz9_1nnwFCG_0zcA1TE8A@mail.gmail.com>
 <20140721152635.GB6363@kroah.com>
 <20140721154307.GG5412@outflux.net>
 <20140721163646.GA14431@kroah.com>
 <CAGXu5jJJsJG94m2EsX2XiH+M1J1nHaJXSrvMMiWbhtxtJN1Zbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJJsJG94m2EsX2XiH+M1J1nHaJXSrvMMiWbhtxtJN1Zbg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:27:33AM -0700, Kees Cook wrote:
> On Mon, Jul 21, 2014 at 9:36 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jul 21, 2014 at 08:43:07AM -0700, Kees Cook wrote:
> >> On Mon, Jul 21, 2014 at 08:26:35AM -0700, Greg Kroah-Hartman wrote:
> >> > On Mon, Jul 21, 2014 at 08:08:16AM -0700, Kees Cook wrote:
> >> > > Perhaps it would be easier if I also sent the patch to udev's helper,
> >> > > so you could see how I propose handling the userspace change to using
> >> > > the new interface?
> >> >
> >> > As there is no more "udev firmware helper", I don't know what you would
> >> > be patching here.  Firmware should always be loaded by the kernel
> >> > directly, udev isn't involved anyore at all.
> >> >
> >> > confused,
> >> >
> >> > greg k-h
> >>
> >> The kernel _can_ load directly (when the paths are configured correctly),
> >> but I'm not sure why you say udev isn't involved any more. It's been like
> >> this for years, and even the latest systemd shows the udev rule is still in
> >> place:
> >> http://cgit.freedesktop.org/systemd/systemd/tree/rules/50-firmware.rules
> >> and that the firmware loader is still in the source tree:
> >> http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-firmware.c
> >
> > Ah, I thought that I had seen patches to delete this code on the systemd
> > mailing list in the past, I didn't realize they hadn't been accepted
> > yet.
> >
> > But, with my current tree, in linux-next, it's really hard to select the
> > "external firmware loader" on purpose, as we want people to use the
> > in-kernel one if at all possible, and only fall back to the "legacy"
> > udev userspace loader if they are running on old userspace systems.
> 
> Heh. Where non-legacy means running a userspace with unaccepted
> systemd patches? That's some serious time-travel. :)

Don't be so sure, I don't think that all distros enable the firmware
option of udev today, so it might be more "real" than you think.

> >> Here's the patch for the new interface...
> >
> > I'd really not like to add a new interface for this model when we are
> > trying to delete it entirely.  Why not just rely on the in-kernel loader
> > instead for this new feature?
> 
> Yeah, I see what you're saying. Obviously if the udev loader is going
> to vanish entirely, it makes no sense to add the "fd" interface. I'll
> keep the last 3 patches in the series in my tree for backporting
> purposes, but since the LSM hook is still useful for origin/content
> validation, I'd still like to see those go in. Though it sounds like I
> should do that through the security-next tree?
> 
> applied:
> doc: fix minor typos in firmware_class README
> test: add firmware_class loader test
> 
> hopefully for security-next:
> security: introduce kernel_fw_from_file hook
> firmware_class: perform new LSM checks
> 
> I'll keep these external for backporting to "legacy" kernels/userspace:
> firmware_class: extract start loading logic
> firmware_class: add "fd" input file
> test: add "fd" firmware loading test to selftests
> 
> Does that look okay?

That's fine with me, or I can take the "security-next" patches through
my tree, if that makes merging with the other firmware patches in my
tree easier (today it's just a line diff, which git can handle easily).

I'll go ack that patch now if James wants to pick it up.

thanks,

greg k-h
