Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3BIVHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 16:07:55 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:47585 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab3BIVHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 16:07:54 -0500
Date: Sat, 9 Feb 2013 16:06:40 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130209210640.GG8091@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Pekka Enberg <penberg@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <levinsasha928@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ingo Molnar <mingo@kernel.org>
References: <20130206214646.GA28135@gmail.com>
 <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com>
 <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 06:57:41AM +1100, Linus Torvalds wrote:
> THAT is my main contention. I told you why I think it's actually
> actively untrue. You claim it helps, but what is it about kvmtool that
> makes it so magically helpful to be inside the kernel repository? What
> is it about this that makes it so critical that you get the kernel and
> kvmtool with a single pull, and they have to be in sync? When you then
> at the same time claim that you make very sure that they don't have to
> be in sync at all. See your earlier emails about how you claim to have
> worked very hard to make sure they work across different versions.

I completely agree with Linus here; in fact, the main reason why it's
important to keep userspace tools outside of the kernel is that it
keeps us careful about interface design.

For example, I consider it a *feature* that when we extend the file
system data structures for ext4, they have to be made in the two
places; once in the kernel, and once in e2fsprogs's version of
ext2_fs.h.  Yes, it might be more convenient if we pushed all of
e2fsprogs into the kernel, so I wouldn't have to edit ext2_fs.h in two
places, but when I make changes to ext2_fs.h, I want to be really
careful, lest I not break backwards compatibility, and to think very
carefully about forward compatibility issues.

If there are constantly huge numbers of interface changes in the
kernel/userspace interface, then it increases the chances that
mistakes will be made.  It's better that those mistakes be caught
early, and if changes need to be made in two places, it increases the
chances that these mistakes will be noticed sooner rather than later.

	     	   	    	    	    - Ted
