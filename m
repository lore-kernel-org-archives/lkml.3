Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3KYQjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab3KYQjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:39:51 -0500
Date: Mon, 25 Nov 2013 11:39:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131125163920.GC23094@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
 <20131121190620.GA25951@srcf.ucam.org>
 <20131121191305.GK16208@redhat.com>
 <20131121191907.GA26366@srcf.ucam.org>
 <20131122185706.GK4046@redhat.com>
 <87vbzju6ql.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbzju6ql.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 07:39:14PM -0800, Eric W. Biederman wrote:

[..]
> > Hmm..., I am running out of ideas here. This is what I understand.
> >
> > - If I sign the bzImage (using PKCS1.5 signature), and later it is signed
> >   with authenticode format signatures, then PKCS1.5 signatures will not be
> >   valid as PE/COFF signing will do some modification to PE/COFF header in
> >   bzImage. And another problem is that then I don't have a way to find
> >   PKCS1.5 signature.
> >
> > - If bzImage is first signed with authenticode format signature and then
> >   signed using PKCS1.5 signature, then  authenticode format signature
> >   will become invalid as it will also hash the data appened at the end
> >   of file.
> >
> > So looks like both signatures can't co-exist on same file. That means
> > one signature has to be detached.
> >
> > I am beginning to think that create a kernel option which allows to choose
> > between attached and detached signatures. Extend kexec syscall to allow
> > a parameter to pass in detached signatures. If detached signatures are
> > not passed, then look for signatures at the end of file. That way, those
> > who are signing kernels using platform specific format (authenticode) in 
> > this case, they can generate detached signature while others can just
> > use attached signatures.
> >
> > Any thoughts on how this should be handled?
> 
> Inside of a modern bzImage there is an embedded ELF image.  How about in
> userspace we just strip out the embedded ELF image and write that to a
> file.  Then we can use the same signature checking scheme as we do for
> kernel modules.  And you only have to support one file format.

I think there is a problem with that. And that we lose the additional
metadata info present in bzImage which is important.

For example, knowing how much memory kernel will consume before it
sets up its own GDT and page tables (init_size) is very important. That
gives image loader lot of flexibility in figuring out where to place rest
of the components safely (initrd, GDT, page tables, ELF header segment, 
backup region etc).

Thanks
Vivek
