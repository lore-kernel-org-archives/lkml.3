Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3EXEug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:50:36 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48162 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3EXEud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:50:33 -0400
Date: Thu, 23 May 2013 23:50:30 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] build some drivers only when compile-testing
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Mahoney <jeffm@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
In-Reply-To: <1369317700.3469.256.camel@deadeye.wl.decadent.org.uk> (from
	ben@decadent.org.uk on Thu May 23 09:01:40 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369371030.2776.17@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 09:01:40 AM, Ben Hutchings wrote:
> On Wed, 2013-05-22 at 19:23 -0700, Greg Kroah-Hartman wrote:
> > On Wed, May 22, 2013 at 11:18:46AM +0200, Jiri Slaby wrote:
> > > Some drivers can be built on more platforms than they run on. This
> > > causes users and distributors packaging burden when they have to
> > > manually deselect some drivers from their allmodconfigs. Or  
> sometimes
> > > it is even impossible to disable the drivers without patching the
> > > kernel.
> > >
> > > Introduce a new config option COMPILE_TEST and make all those  
> drivers
> > > to depend on the platform they run on, or on the COMPILE_TEST  
> option.
> > > Now, when users/distributors choose COMPILE_TEST=n they will not  
> have
> > > the drivers in their allmodconfig setups, but developers still can
> > > compile-test them with COMPILE_TEST=y.
> >
> > I understand the urge, and it's getting hard for distros to handle  
> these
> > drivers that just don't work on other architectures, but it's really
> > valuable to ensure that they build properly, for those of us that  
> don't
> > have many/any cross compilers set up.

In http://landley.net/aboriginal/bin grab the cross-compiler-*.tar.bz2  
tarballs, extract them, add the "bin" subdirectory of each to the  
$PATH. Congratulations, you have cross compilers set up. (They're  
statically linked and relocatable, so should run just about anywhere.  
If they don't, let me know and I'll fix it.)

Example build:

   make ARCH=sparc sparc32_defconfig
   PATH=/home/landley/simple-cross-compiler-sparc/bin:$PATH \
     make ARCH=sparc CROSS_COMPILE=sparc-

Rob