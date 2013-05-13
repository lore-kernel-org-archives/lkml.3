Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3EMODK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3EMODJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:03:09 -0400
Date: Mon, 13 May 2013 15:59:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
Message-ID: <20130513135947.GA1613@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com> <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com> <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com> <20130510171054.GA27479@redhat.com> <20130510173511.GA28490@redhat.com> <CAKi4VAK3paytaMGBmu0oVGcLUeuCbL7i3aht-Ho7rz7cdf5KTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAK3paytaMGBmu0oVGcLUeuCbL7i3aht-Ho7rz7cdf5KTg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Lucas De Marchi wrote:
>
> On Fri, May 10, 2013 at 2:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 05/10, Oleg Nesterov wrote:
> >>
> >> > > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
> >> > > +char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
> >>
> >> No. This is incompatible change, we shouldn't do this.
> >
> > Exactly. This can break a distro which writes to sys/kernel/modprobe.
> >
> > And if we do not do this, you can simply make a single trivial patch
> > which does
...
> > that it all. (or perhaps a kernel parameter makes more sense).
> >
> > Yes, this doesn't allow to pass the additional arguments, but is it
> > that important?
>
> Yes, because I don't want to simply change the binary to use, I want
> to be able to use a general "kmod" binary that accept a command like
> "load". Next version of kmod will accept things like this (see the
> commit message in patch 3/3):

Well, but a link to the binary which checks argv[0] or a trivial executable
which simply execs "kmod load" looks like the simple workaround. And this
doesn't need to recompile the kernel.

Lucas, I simply do not know...

Andrew, Rusty, what do you think? Can we do the change above? Do we
really want CONFIG_MODPROBE_PATH or a kernel parameter ?

Oleg.

