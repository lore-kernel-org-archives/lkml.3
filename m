Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3CIFNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 00:13:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3CIFNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 00:13:00 -0500
Message-ID: <513AC4EC.6090104@oracle.com>
Date: Sat, 09 Mar 2013 00:13:16 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
References: <20130309020318.GA11449@redhat.com> <CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com> <20130309022623.GB11449@redhat.com> <20130309025631.GA13188@redhat.com> <20130309025752.GA13913@redhat.com> <CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com> <20130309032530.GA19839@redhat.com> <CA+55aFweyfew3VU79ZQV4otJcWiF0=xKXxDtADXcccNxGaqMwA@mail.gmail.com> <20130309035053.GA1396@redhat.com> <CA+55aFz9d70DCixqNdmit=OHmUi3kB9p14TDVyEvO_yRZ=2FTg@mail.gmail.com> <20130309043912.GA2797@redhat.com>
In-Reply-To: <20130309043912.GA2797@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 11:39 PM, Dave Jones wrote:
> On Fri, Mar 08, 2013 at 08:31:48PM -0800, Linus Torvalds wrote:
>  > On Fri, Mar 8, 2013 at 7:50 PM, Dave Jones <davej@redhat.com> wrote:
>  > >  > >
>  > >  > > I have a feeling there were some sysfs ones that may still be unfixed.
>  > >
>  > > I was right..
>  > >
>  > > [  425.836722] general protection fault: 0000 [#1] PREEMPT SMP
>  > 
>  > You forgot to enable DEBUG_PAGE_ALLOC again, but I don't think it much
>  > matters. It's another slab free poison thing.
>  > 
>  > The faulting instruction is
>  > 
>  >     mov    0x28(%rbx),%ecx
>  > 
>  > with %rbx having the value 6b6b6b6b6b6b6b6b.
>  > 
>  > > [  425.847859] RIP: 0010:[<ffffffff8123f657>]  [<ffffffff8123f657>] sysfs_find_dirent+0x47/0xf0
>  > 
>  > That seems to be
>  > 
>  >     if (hash != sd->s_hash)
>  > 
>  > from sysfs_name_compare() that has been inlined into
>  > sysfs_find_dirent(). And where "sd" is the corrupted value. If I read
>  > things right.
>  > 
>  > So it looks like the sysfs rbtree is corrupted or something. Adding
>  > Greg to the cc.
>  
> oh , that rings a bell.  ISTR this had something to do with Sasha's idr changes.

I believe the issue you're referring to is my report of a panic in sysfs keys
where the device has gone away? If that is it, I don't think that this issue
is related to that one.

If not, I'm not sure which change you're referring to.


Thanks,
Sasha

