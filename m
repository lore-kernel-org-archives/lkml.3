Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaHIOTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:19:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaHIOT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:19:28 -0400
Date: Sat, 9 Aug 2014 07:16:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
Message-ID: <20140809141609.GA21639@kroah.com>
References: <20140808213457.511493898@linuxfoundation.org>
 <53E57279.1030106@roeck-us.net>
 <20140809034911.GA2348@kroah.com>
 <20140809034950.GB2348@kroah.com>
 <53E5A0D1.10507@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E5A0D1.10507@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:17:21PM -0700, Guenter Roeck wrote:
> On 08/08/2014 08:49 PM, Greg Kroah-Hartman wrote:
> >On Fri, Aug 08, 2014 at 08:49:11PM -0700, Greg Kroah-Hartman wrote:
> >>On Fri, Aug 08, 2014 at 05:59:37PM -0700, Guenter Roeck wrote:
> >>>On 08/08/2014 02:35 PM, Greg Kroah-Hartman wrote:
> >>>>This is the start of the stable review cycle for the 3.16.1 release.
> >>>>There are 17 patches in this series, all will be posted as a response
> >>>>to this one.  If anyone has any issues with these being applied, please
> >>>>let me know.
> >>>>
> >>>>Responses should be made by Sun Aug 10 21:34:49 UTC 2014.
> >>>>Anything received after that time might be too late.
> >>>>
> >>>
> >>>Build results:
> >>>	total: 136 pass: 136 fail: 0
> >>
> >>That's more than 3.15, nice!
> >
> >Oops, no, one less.  What got dropped from 3.16 that was working in 3.14
> >and 3.15?
> >
> 
> 3.16 adds arm:axm55x_defconfig, and drops ppc:chroma_defconfig.
> ppc is built twice, once with binutils 2.23 and once with binutils 2.24,
> so it counts double. So net it is one less build. I may make up for that
> and select a different configuration as replacement, but that will have
> to wait until 3.17-rc1 is out.
> 
> Just for reference, in mainline, we currently have
> 	total: 133 pass: 127 fail: 6
> plus four (!) qemu tests failing (arm, mips, mips64, and ppc),
> meaning there will be three more dropped configurations (all arm
> as far as I can see), and there is already a bunch of failures.
> This is with v3.16-9794-g8065be8. next-20140808 build result is
> 	total: 133 pass: 121 fail: 12
> with the same failed qemu tests, so it will only get worse :-(.
> 
> Some improved quality assurance may be helpful going forward,
> especially since many of the failures seem to be due to lack of
> (build) testing and could easily have been avoided. Something
> to discuss in Chicago, maybe.

I wonder if it is just due to the merge not being finished yet?  The
0-day built-bot should have caught any major build issues before now
with the individual trees, so there shouldn't be any reason you should
be seeing failures :(

And yes maybe we should talk about it in Chicago...

greg k-h
