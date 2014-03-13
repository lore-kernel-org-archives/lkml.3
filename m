Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaCMXBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:01:55 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59973 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbaCMXBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <59774.1394739168@turing-police.cc.vt.edu>
References: <59774.1394739168@turing-police.cc.vt.edu>
Date: Thu, 13 Mar 2014 16:01:51 -0700
X-Google-Sender-Auth: xm1c3dxHVibAvU9a3OkHAGhAorY
Message-ID: <CAL3LdT79V+NLJ9Kd8aX+qnmKfJag2rn7Smdteq=kWYeJOLSe3g@mail.gmail.com>
Subject: Re: [E1000-devel] next-20140313 - build error in e1000e driver
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:32 PM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> My kernel has CONFIG_PM_SLEEP=n, which leads to hilarity...
>
>   CC      drivers/net/ethernet/intel/e1000e/netdev.o
> drivers/net/ethernet/intel/e1000e/netdev.c:7079:13: error: 'e1000e_pm_suspend' undeclared here (not in a function)
>   .suspend = e1000e_pm_suspend,
>              ^
> drivers/net/ethernet/intel/e1000e/netdev.c:7080:13: error: 'e1000e_pm_resume' undeclared here (not in a function)
>   .resume  = e1000e_pm_resume,
>              ^
> make[5]: *** [drivers/net/ethernet/intel/e1000e/netdev.o] Error 1
> make[4]: *** [drivers/net/ethernet/intel/e1000e] Error 2
> make[3]: *** [drivers/net/ethernet/intel] Error 2
> make[2]: *** [drivers/net/ethernet] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
>
> Commit 38a529b5d4 claims to fix a related issue, but doesn't seem to do so correctly.
>
> Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> Date:   Thu Jan 16 14:39:39 2014 +0200
>
>     e1000e: Fix compilation warning when !CONFIG_PM_SLEEP
>
>     Commit 7509963c703b (e1000e: Fix a compile flag mis-match for
>     suspend/resume) moved suspend and resume hooks to be available when
>     CONFIG_PM is set. However, it can be set even if CONFIG_PM_SLEEP is not set
>     causing following warnings to be emitted:
>
>     drivers/net/ethernet/intel/e1000e/netdev.c:6178:12: warning:
>         â€˜e1000_suspendâ€™ defined but not used [-Wunused-function]
>
>     drivers/net/ethernet/intel/e1000e/netdev.c:6185:12: warning:
>         â€˜e1000_resumeâ€™ defined but not used [-Wunused-function]
>

I believe David Ertman fixed this and David Miller's net-next tree
contains the patch that resolved this.
