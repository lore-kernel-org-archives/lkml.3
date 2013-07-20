Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3GTQt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:49:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab3GTQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:49:55 -0400
Date: Sat, 20 Jul 2013 09:50:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/38] 3.9.11-stable review
Message-ID: <20130720165004.GA3688@kroah.com>
References: <20130719052047.858393825@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E6174192D@sisaex01sj>
 <20130719192524.GB2428@kroah.com>
 <20130719234723.GA11456@kroah.com>
 <B8EFE96D1287C24090BAD9D858E15E61746BA3@sisaex01sj>
 <B8EFE96D1287C24090BAD9D858E15E61746DA5@sisaex01sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61746DA5@sisaex01sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 04:34:41PM +0000, Shuah Khan wrote:
> On 07/19/2013 06:10 PM, Shuah Khan wrote:
> > On 07/19/2013 05:50 PM, Greg Kroah-Hartman wrote:
> >> On Fri, Jul 19, 2013 at 12:25:24PM -0700, Greg Kroah-Hartman wrote:
> >>> On Fri, Jul 19, 2013 at 04:45:25PM +0000, Shuah Khan wrote:
> >>>> On 07/19/2013 09:34 AM, Greg Kroah-Hartman wrote:
> >>>>> ---------------
> >>>>> Note, this is the LAST 3.9-stable kernel release that I will be doing.
> >>>>> Please move to the 3.10-stable branch as soon as possible.
> >>>>> ---------------
> >>>>>
> >>>>> This is the start of the stable review cycle for the 3.9.11 release.
> >>>>> There are 38 patches in this series, all will be posted as a response
> >>>>> to this one.  If anyone has any issues with these being applied, please
> >>>>> let me know.
> >>>>>
> >>>>> Responses should be made by Sun Jul 21 05:20:01 UTC 2013.
> >>>>> Anything received after that time might be too late.
> >>>>>
> >>>>> The whole patch series can be found in one patch at:
> >>>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.11-rc1.gz
> >>>>> and the diffstat can be found below.
> >>>>>
> >>>>> thanks,
> >>>>>
> >>>>> greg k-h
> >>>>>
> >>>>
> >>>> Greg,
> >>>>
> >>>> Build failed with the following error:
> >>>>
> >>>>      LD      ipc/built-in.o
> >>>>      CC [M]  fs/cifs/inode.o
> >>>> fs/cifs/inode.c: In function ‘cifs_all_info_to_fattr’:
> >>>> fs/cifs/inode.c:560:4: error: implicit declaration of function
> >>>> ‘cifs_dbg’ [-Werror=implicit-function-declaration]
> >>>> cc1: some warnings being treated as errors
> >>>> make[2]: *** [fs/cifs/inode.o] Error 1
> >>>> make[1]: *** [fs/cifs] Error 2
> >>>> make: *** [fs] Error 2
> >>>> make: *** Waiting for unfinished jobs....
> >>>>      CC      security/selinux/hooks.o
> >>>>
> >>>> I have CONFIG_CIFS=m in my config and CONFIG_CIFS_DEBUG is disabled.
> >>>> cifs_dbg() is not defined.
> >>>
> >>> Ugh, I thought I fixed that one...  I did it for the 3.4 and other
> >>> trees, I'll go see what I did wrong...
> >>
> >> Ok, I've now fixed this, I don't know how it got through my tests, when
> >> I tried it again, it failed.  Before it wasn't, odd...
> >>
> >> Anyway, there is a new -rc2 kernel patch at:
> >>    	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.11-rc2.gz
> >>
> >> If you could test that out, I would appreciate it, to ensure I didn't do
> >> anything stupid with this one too.
> >>
> >> Ick, handling 4 kernels at once really takes its toll on me, this was
> >> not a good review cycle...
> >>
> >> thanks,
> >>
> >> greg k-h
> >>
> >
> > Greg,
> >
> > rc2 compiled on x86-64. I will run cross-compile tests and boot tests
> > later on today or tomorrow morning and report the results.
> >
> > -- Shuah
> >
> > Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research
> > America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
> >
> 
> 3.9.11-rc2 boot tests passed on my test systems and cross-compile tests 
> passed. No regressions in dmesgs.

Wonderful, thanks so much for testing and letting me know.

greg k-h
