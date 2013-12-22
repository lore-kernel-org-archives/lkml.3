Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3LVFQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 00:16:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3LVFQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 00:16:30 -0500
Message-ID: <1387689387.5412.53.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: muli.baron@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Sun, 22 Dec 2013 06:16:27 +0100
In-Reply-To: <1387685830.5412.37.camel@marge.simpson.net>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
	 <20131220154146.GA18672@breakpoint.cc>
	 <1387617104.30230.7.camel@marge.simpson.net> <52B5CE09.5030908@gmail.com>
	 <1387685830.5412.37.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:k8hP8XyVJ2yZwLKz6QrCiPKbO+rcnfylFefRGGfUE5P
 w8kdeXMu1waYVToUK7acrB+kTF35HextZZYvInGlBRVMH9O2rI
 n5VZ9YtXnUny89ETWUjzrSzoB6qiu2y8+pyHFfIt5/65OJhBPa
 NcPUFTa/gGh71dETT9k78qaLUsfAjIAExOz9ruR8H7zoaunL4R
 JFULgBTICUzlzgpUlQQuaUgsMhKLI+6lLTXuJJ4lykUQkvVoFS
 Y5zln86W8FbUGKAu6R9qkEhtzHwCDNrUJnwCtyX28/SvhY5LT8
 pi2OAhFsMd++mtMe4c4v0OgdePbP5/EvX4IRFbdODjlWv9Rw+d
 +rrTEeFX8KN0QQ6UPH0I9+XBSs4L/ZL6PIy918fcA0C0K8a8dU
 YZ4DvnGXJkQ7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-22 at 05:17 +0100, Mike Galbraith wrote: 
> On Sat, 2013-12-21 at 19:21 +0200, Muli Baron wrote: 
> > On 21/12/2013 11:11, Mike Galbraith wrote:
> > >
> > > Works, modulo noisy workqueues.
> > >
> > > rtbox:~ # sleep 35 && killall pert& cgexec -g cpuset:rtcpus taskset -c 3 pert 5
> > > [1] 5660
> > > 2400.05 MHZ CPU
> > > perturbation threshold 0.018 usecs.
> > > pert/s:       33 >15.75us:        2 min:  0.04 max: 24.14 avg:  2.51 sum/s:    84us overhead: 0.01%
> > > pert/s:       35 >15.54us:        3 min:  0.04 max: 24.89 avg:  2.39 sum/s:    84us overhead: 0.01%
> > > pert/s:       30 >15.27us:        2 min:  0.04 max: 23.03 avg:  2.64 sum/s:    80us overhead: 0.01%
> > > pert/s:       34 >15.12us:        3 min:  0.04 max: 25.03 avg:  2.51 sum/s:    86us overhead: 0.01%
> > > pert/s:       31 >14.93us:        2 min:  0.04 max: 23.86 avg:  2.60 sum/s:    83us overhead: 0.01%
> > > Terminated
> > >
> > 
> > I can confirm this works for me as well, but I have noticed some strange behavior under certain 
> > conditions.
> 
> Hm, so can I.  Same everything, different day, nohz_full is NOT working.

But while I was off futzing with DL980, it started working all by
itself, after not working _at all_ for three reboot/play attempts.  

There's a phase-of-moon bug lurking in there somewhere.

-Mike


