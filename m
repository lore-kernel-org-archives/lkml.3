Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3GXKmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:42:50 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.69]:46792 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3GXKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:42:48 -0400
X-Greylist: delayed 1015 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2013 06:42:48 EDT
Date: Wed, 24 Jul 2013 22:25:44 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: Richard Henderson <rth@twiddle.net>
Cc: Michael Cree <cree@waikato.ac.nz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 0/7] Minor Alpha updates for 3.11
Message-ID: <20130724102544.GA7713@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	Richard Henderson <rth@twiddle.net>,
	Michael Cree <cree@waikato.ac.nz>, Rob Landley <rob@landley.net>,
	linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
	mattst88@gmail.com, linux-alpha@vger.kernel.org
References: <20130717000347.GB2483@stolen.phys.waikato.ac.nz>
 <1374546701.3719.33@driftwood>
 <20130723032511.GA18086@stolen.phys.waikato.ac.nz>
 <51EE9F36.7050402@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE9F36.7050402@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Check: by mx6.orcon.net.nz on Wed, 24 Jul 2013 22:25:50 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Jul 24 22:25:50 2013
X-DSPAM-Confidence: 0.6185
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06K4aGJv1 - 564df533100f - 20130724
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 07:20:22AM -0800, Richard Henderson wrote:
> On 07/22/2013 07:25 PM, Michael Cree wrote:
> > I wondered if your proposal will break glibc as glibc checks for
> > __NR_oldumount and does different things based on that.  But maybe your
> > fix will not adversely affect glibc (I did not look particularly closely
> > to see if so), but even so, there is no guarantee that other software does
> > not directly access the oldumount syscall when compiled on Alpha, and your
> > change would likely break any such software.
> 
> It won't break glibc.  While there are conditionals for oldumount,
> they do pretty much exactly the umount/umount2 dance you'd expect.

That's good to hear.

> I'm for the patch, because anything that makes us match x86 more
> closely has got to be a good thing from a portability standpoint.

OK, but I think that behoves us to make an effort to check user space
applications are compliant with the change.  Fortunately we can easily
scheck the vast majority of opensource programs now that Debian
provides a web interface for searching the source code of all their
packages.

Searching for NR_umount finds the following packages that compile on
Alpha:

eglibc
dietlibc
uclibc
qemu
radare
linux-tools
ns3
skyeye
(and a few others that are not buildable on Alpha and tons of
hits for every version of the linux kernel that result from every arch
directory therein...)

I'm happy to take a closer look at them and submit a patch to their upstreams
if need be.

Cheers
Michael.
