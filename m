Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3LSNDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:03:17 -0500
Received: from verein.lst.de ([213.95.11.211]:55140 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3LSNDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:03:14 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 08:03:14 EST
Date: Thu, 19 Dec 2013 13:54:39 +0100
From: Torsten Duwe <duwe@lst.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
	kernel kexec
Message-ID: <20131219125439.GA6379@lst.de>
References: <1384969851-7251-5-git-send-email-vgoyal@redhat.com> <20131121190350.GC17070@kroah.com> <20131121190620.GA25951@srcf.ucam.org> <20131121191305.GK16208@redhat.com> <20131121191907.GA26366@srcf.ucam.org> <20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com> <20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com> <20131126142759.GA5473@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126142759.GA5473@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 09:27:59AM -0500, Vivek Goyal wrote:
> On Tue, Nov 26, 2013 at 04:23:36AM -0800, Eric W. Biederman wrote:
> > Vivek Goyal <vgoyal@redhat.com> writes:
> > 
> > > On Fri, Nov 22, 2013 at 07:39:14PM -0800, Eric W. Biederman wrote:
> > >
> > 
> > The init_size should be reflected in the .bss of the ELF segments.  If
> > not it is a bug when generating the kernel ELF headers and should be
> > fixed.
> > 
> > For use by kexec I don't see any issues with just signing the embedded
> > ELF image.
> 
> Being able to write kernel to a file and then load it feels little odd to
> me. Though this should be allowed but this should not be mandatory.
> 
> I think if we allow passing detached signature in kexec system call, then
> it makes it much more flexible. We should be able to do what you are
> suggesting at the same time it will also keep the possibility open for what
> chromeOS developers are looking for.
> 
Support for detached signatures would be a big plus for kexec_file_load.

First I thought, some vendors are already shipping signed bzImages, why not
verify these? But as it turns out, parsing MS-DOS, PE/COFF headers just to
find the gaps is a lot of bloat for this little functionality. And David Howells
got flamed quite badly when he suggested to add pkcs#7 to the kernel.
IMO it's up to user land to search lists of certificates, and present
only the final chain of trust to the kernel for checking.

ELF is the preferred format for most sane OSes and firmware, and a detached
signature would probably be simplest to check. If we have the choice,
without restrictions from braindead boot loaders, ELF should be first.
And if the pesigning isn't usable and another sig is needed anyway,
why not apply that to vmlinux(.gz) ?

Another remaining issue is the root of trust. Should the kernel solely depend
on UeFI to check certificates? I'd rather vote for a compile-time fallback key.

	Torsten

