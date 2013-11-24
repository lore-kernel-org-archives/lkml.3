Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3KXTbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 14:31:20 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42088 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3KXTbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 14:31:19 -0500
Date: Sun, 24 Nov 2013 11:51:42 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Correct parameter size for BLKSSZGET ioctl.
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jason Cipriani <jason.cipriani@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20131103194314.GB7376@thunk.org> (from tytso@mit.edu on Sun
	Nov  3 13:43:14 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1385315502.1974.283@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 01:43:14 PM, Theodore Ts'o wrote:
> On Sun, Nov 03, 2013 at 02:07:56PM -0500, Jason Cipriani wrote:
> >
> > There was a bigger question hidden behind the context there that I'm
> > still wondering about: Are these ioctl interfaces specified and
> > documented somewhere? From what I've seen, and from your response,  
> the
> > implication is that the kernel source *is* the specification, and  
> not
> > document exists that the kernel is expected to comply with; is this
> > the case?
> 
> The kernel source is the specification.  Some of these ioctl are
> documented as part of the linux man pages, for which the project home
> page is here:
> 
>      https://www.kernel.org/doc/man-pages/

Specifically "man ioctl_list"

> However, these document existing practice; if there is a discrepancy
> between what is in the kernel has implemented and the Linux man pages,
> it is the Linux man pages which are buggy and which will be changed.
> That is man pages are descriptive, not perscriptive.

Although if something obvious is missing or wrong, it's nice to ping  
Michael Kerrisk so he can update it.

> > Secondly, would it not make sense to change all ints in all public
> > kernel interfaces to data types with a well-defined, machine- and
> > (mostly) compiler-independent size, e.g. int32_t (or whatever)?

Allow me to introduce you to the LP64 specification, which Linux, BSD,  
and MacOS X all adhere to:

http://www.unix.org/whitepapers/64bit.html
http://www.unix.org/version2/whatsnew/lp64_wp.html

It says that char is 8 bits, short is 16 bits, int is 32 bits, and long  
is the same size as a pointer (32 bits on 32 bit platforms, 64 bits on  
64 bit platforms). There's a de-facto "long long is 64 bits" assumption  
in fairly widespread use, but it's not explicit in the standard.

(Welcome to the 21st century, where we know what sizes our data types  
are even _without_ c99.)

Rob

P.S. The insane legacy reasons that Windows does _not_ adhere to this  
standard are documented at:

http://blogs.msdn.com/oldnewthing/archive/2005/01/31/363790.aspx

(So if you're wondering why qemu has "pointer sized int" typedefs in  
its' source, it's because they care about running on windows. And even  
if you did care about that, you can still rely on the sizes of char,  
short, and int.)