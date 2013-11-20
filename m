Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3KTQ1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:27:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3KTQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:27:19 -0500
Date: Wed, 20 Nov 2013 08:27:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amir Shehata <amir.shehata@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 4/9] staging/lustre/lnet: Fix assert on empty group in
 selftest module
Message-ID: <20131120162745.GA5831@kroah.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
 <1384867428-8395-5-git-send-email-bergwolf@gmail.com>
 <20131119183714.GA26216@kroah.com>
 <CA+a=Yy531J9LZv06P2aAHPSw_0jtNY+wdNExpLVOW9ee+8Ja1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy531J9LZv06P2aAHPSw_0jtNY+wdNExpLVOW9ee+8Ja1A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 05:26:57PM +0800, Peng Tao wrote:
> On Wed, Nov 20, 2013 at 2:37 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Nov 19, 2013 at 09:23:43PM +0800, Peng Tao wrote:
> >> From: Amir Shehata <amir.shehata@intel.com>
> >>
> >> The core of the issue is that the selftest module doesn't sanitize its
> >> own API, but it depends on lst utility to do such checks.  As a result
> >> this issue manifests itself in this particular LU through an assert
> >> on an empty group.  If the NID is misspelled then an empty group is
> >> added.  An error output is provided, but if that's never checked in a
> >> batch script, as is the case with this issue, then the script will try
> >> to add an empty group to a test to run in a batch, and that will cause
> >> an assert
> >>
> >> The fix is two fold.  Ensure that lst utility checks that a group is
> >> added with at least one node.  If not the group is subsequently
> >> deleted.  And the add_test command would fail, since the group no
> >> longer exists.
> >>
> >> The second fix is to ensure that the kernel module itself sanitizes
> >> its own API in this particular case, so that if a different utility is
> >> used other than lst to communicate with the selftest kernel module
> >> then this error would be caught.  This fix looks up the batch and the
> >> groups, src and dst, in the ioctl handle and sanitizes that input at
> >> this point.  If the group looked up either doesn't exist or doesn't
> >> have at least one ACTIVE node, then the command fails.
> >>
> >> NOTE:there are many other cases in the code where the selftest kernel
> >> module doesn't check for sanity of the input, but depends totally on
> >> the lst module to do such checks.  Particularly around length of
> >> strings passed in.  Thus it is possible to crash the selftest module
> >> if someone tries to create another userspace app to communicate with
> >> the selftest kernel module without ensuring sanity of the params sent
> >> to the kernel module.  In effect, it's always assumed that lst is the
> >> front end for selftest and no other front end is to be used.
> >
> > This patch adds build warnings to the kernel build process, so I can't
> > apply it, sorry.  Please fix that up before sending it again.
> >
> Hi Greg,
> 
> Can you please be explicit about what build warning you saw?

I don't remember what it was at the moment, sorry.

> I tried to reproduce it with gcc version 4.1.2 and 4.6.3 on my
> machine, but didn't see any build warnings with this patch applied.

I have 4.7.3 here, and x86-64.  Try that and see what happens.

greg k-h
