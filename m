Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3G1Sjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:39:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3G1Sjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:39:45 -0400
Date: Sun, 28 Jul 2013 11:39:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux@roeck-us.net, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/45] 3.0.88-stable review
Message-ID: <20130728183944.GB27253@kroah.com>
References: <20130726205654.896050165@linuxfoundation.org>
 <20130727062230.5580181gtrfxe83k@67.228.131.205>
 <1374967837.3607.31.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374967837.3607.31.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 12:30:37AM +0100, Ben Hutchings wrote:
> On Sat, 2013-07-27 at 06:22 -0500, linux@roeck-us.net wrote:
> > Quoting Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> > 
> > > This is the start of the stable review cycle for the 3.0.88 release.
> > > There are 45 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun Jul 28 20:54:53 UTC 2013.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.88-rc1.gz
> > > and the diffstat can be found below.
> > >
> > We have additional build failures.
> > 
> > Total builds: 54 Total build errors: 20
> > 
> > Link:  
> > http://desktop.roeck-us.net/buildlogs/v3.0.87-45-g367423c.2013-07-27.03:09:16
> > 
> > Previously:
> > Total builds: 54 Total build errors: 17
> > 
> > Additional failures are i386/allmodconfig, i386/allyesconfig and mips/malta.
> > 
> > I don't have time to track down the culprit tonight (I am still in  
> > Down Under ;). I hope I can do it tomorrow.
> 
> I iterated through the 3.0 patch queue with i386/allmodconfig, and got
> to:
> 
> Applying patch ifb-fix-rcu_sched-self-detected-stalls.patch
> patching file drivers/net/ifb.c
> 
> Now at patch ifb-fix-rcu_sched-self-detected-stalls.patch
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   LD      arch/x86/built-in.o
>   CC [M]  drivers/net/ifb.o
> drivers/net/ifb.c: In function ‘ifb_init_module’:
> drivers/net/ifb.c:257:3: error: implicit declaration of function ‘cond_resched’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/net/ifb.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
> 
> I think this patch needs to add a '#include <linux/sched.h>', but that
> header is being included indirectly in some other configurations (and in
> mainline).
> 
> With that change, I can apply the remaining patches and compile
> 3.0.88-rc1 successfully.

Odd that this didn't trigger on x86-64.  Anyway, thanks, I've made this
change to the patch, so all should be good in the final version.  If
not, please let me know.

thanks,

greg k-h
