Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3DVS7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 14:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3DVS7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:59:47 -0400
Date: Mon, 22 Apr 2013 14:59:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Pan, Zhenjie" <zhenjie.pan@intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-ID: <20130422185929.GZ79013@redhat.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
 <1366285369.19383.19.camel@laptop>
 <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
 <20130418133927.GJ79013@redhat.com>
 <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 12:50:34AM +0000, Pan, Zhenjie wrote:
> > I believe it mattered to the Chrome folks. They want the watchdog to be as
> > tight as possible so the user experience isn't a hang but a quick reboot
> > instead.  They like setting the watchdog to something like 2 seconds.
> > 
> > There was a patch a few months ago that tried to hack around this issue and I
> > suggested this approach as a better solution.  I forgot what the original
> > problem was.  Perhaps someone can jump in and explain the problem being
> > solved (other than the watchdog isn't always 10 seconds)?
> > 
> > Cheers,
> > Don
> 
> Yes, I also think the period is important sometimes.
> As I mentioned before, the case I meet is:
> When the system hang with interrupt disabled, we use NMI to detect.
> Then it will find hard lockup and cause a panic.
> Panic is very important for debug these kind of issues.
> 
> But if cpu frequency change, the period will be 2 times, 3 times even more.(if cpu can down from 2.0GHz to 200MHz, will be 10 times, it's a very big deviation)
> This make watchdog reset happen before hard lockup detect.

So you are saying with the longer hard lockup delay, the iTCO_wdt is
firing before the hard lockup detector?

Cheers,
Don
