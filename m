Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3CIFQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 00:16:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3CIFQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 00:16:51 -0500
Date: Sat, 9 Mar 2013 00:16:43 -0500
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309051643.GB2797@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20130309022623.GB11449@redhat.com>
 <20130309025631.GA13188@redhat.com>
 <20130309025752.GA13913@redhat.com>
 <CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
 <20130309032530.GA19839@redhat.com>
 <CA+55aFweyfew3VU79ZQV4otJcWiF0=xKXxDtADXcccNxGaqMwA@mail.gmail.com>
 <20130309035053.GA1396@redhat.com>
 <CA+55aFz9d70DCixqNdmit=OHmUi3kB9p14TDVyEvO_yRZ=2FTg@mail.gmail.com>
 <20130309043912.GA2797@redhat.com>
 <513AC4EC.6090104@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513AC4EC.6090104@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 12:13:16AM -0500, Sasha Levin wrote:
 > On 03/08/2013 11:39 PM, Dave Jones wrote:
 > > On Fri, Mar 08, 2013 at 08:31:48PM -0800, Linus Torvalds wrote:
 > >  > On Fri, Mar 8, 2013 at 7:50 PM, Dave Jones <davej@redhat.com> wrote:
 > >  > >  > >
 > >  > >  > > I have a feeling there were some sysfs ones that may still be unfixed.
 > >  > >
 > >  > > I was right..
 > >  > >
 > >  > > [  425.836722] general protection fault: 0000 [#1] PREEMPT SMP
 > >  > 
 > >  > You forgot to enable DEBUG_PAGE_ALLOC again, but I don't think it much
 > >  > matters. It's another slab free poison thing.
 > >  > 
 > >  > The faulting instruction is
 > >  > 
 > >  >     mov    0x28(%rbx),%ecx
 > >  > 
 > >  > with %rbx having the value 6b6b6b6b6b6b6b6b.
 > >  > 
 > >  > > [  425.847859] RIP: 0010:[<ffffffff8123f657>]  [<ffffffff8123f657>] sysfs_find_dirent+0x47/0xf0
 > >  > 
 > >  > That seems to be
 > >  > 
 > >  >     if (hash != sd->s_hash)
 > >  > 
 > >  > from sysfs_name_compare() that has been inlined into
 > >  > sysfs_find_dirent(). And where "sd" is the corrupted value. If I read
 > >  > things right.
 > >  > 
 > >  > So it looks like the sysfs rbtree is corrupted or something. Adding
 > >  > Greg to the cc.
 > >  
 > > oh , that rings a bell.  ISTR this had something to do with Sasha's idr changes.
 > 
 > I believe the issue you're referring to is my report of a panic in sysfs keys
 > where the device has gone away? If that is it, I don't think that this issue
 > is related to that one.
 > 
 > If not, I'm not sure which change you're referring to.

Hmm I might have been thinking of the hlist changes rather than idr.
Though looking at those oopses, they were in find_pid_ns, so different.

So many bugs.

	Dave

 
