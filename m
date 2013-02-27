Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab3B0OOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:14:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760008Ab3B0OOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:14:30 -0500
Date: Wed, 27 Feb 2013 09:14:12 -0500
From: Peter Jones <pjones@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130227141412.GA6427@fenchurch.internal.datastacks.com>
References: <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <20130226042338.GA30944@srcf.ucam.org>
 <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
 <CAMuHMdV4DbX_i6Ye5v7ObR0no-eDhBzqYrsqVtR5PAXQTVSmVQ@mail.gmail.com>
 <20130226220618.GK32160@fenchurch.internal.datastacks.com>
 <CAMuHMdUQxX+3kSN+UorapS5a3kZaNrBpY1Nch8nLniMU-w9-DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdUQxX+3kSN+UorapS5a3kZaNrBpY1Nch8nLniMU-w9-DA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 01:32:30PM +0100, Geert Uytterhoeven wrote:
> On Tue, Feb 26, 2013 at 11:06 PM, Peter Jones <pjones@redhat.com> wrote:
> > On Tue, Feb 26, 2013 at 10:57:38PM +0100, Geert Uytterhoeven wrote:
> >
> >> BTW, I assume UEFI checks itself if enrolled hashes have been revoked,
> >> so it must phone home to some server? That must be disabled as well.
> >
> > No.  Quit fearmongering.
> 
> Good to know, thanks!
> 
> So revocation will only be done by the guest OS?
> I.e. if I only boot my own trusted Linux, even if it's signed with the MS key,
> the MS key _on my system_ will never be revoked?

Something must apply the dbx update.  We'll certainly do so in Fedora and
RHEL, from userland, but you're certainly in a position to make it not
happen in your own trusted linux, and even on a Fedora or RHEL machine
you maintain.  But there's no "phoning home" involved - the plan is to
make that happen as a regular package update to shim-signed, so here you
go:

--- /etc/yum.conf.old	2013-02-27 09:10:25.181998268 -0500
+++ /etc/yum.conf	2013-02-27 09:10:34.423403583 -0500
@@ -21,3 +21,4 @@
 
 # PUT YOUR REPOS HERE OR IN separate files named file.repo
 # in /etc/yum.repos.d
+exclude=shim-signed

And as long as you never boot Windows on the thing, you're set.
-- 
        Peter
