Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbbAIO5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:57:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789AbbAIO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:57:11 -0500
Date: Fri, 9 Jan 2015 09:56:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org, mtosatti@redhat.com
Subject: Re: [PATCH 0/2] Quieten softlockup detector on virtualised kernels
Message-ID: <20150109145651.GE116159@redhat.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
 <20150105165057.GU116159@redhat.com>
 <1420502015.2910.6.camel@cyril>
 <20150106150157.GF116159@redhat.com>
 <1420773300.2801.13.camel@cyril>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420773300.2801.13.camel@cyril>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 02:15:00PM +1100, Cyril Bur wrote:
> > 
> > I am not too familar with it, but the kernel/watchdog.c code has calls to
> > kvm_check_and_clear_guest_paused(), which is probably a good place to
> > start.
> > 
> Ah yes that, I did initially have a look at what it does when I
> undertook to solve the problem on power and I suppose the two solutions
> are similar in that they both just use a virtualised time source. The
> similarities stop there though, the paravirtualised clock that x86 uses
> provides (as the name of the function implies) a 'was paused' flag.
> Obviously the flag isn't something the vtb register on power8 can
> provide and since we have a vtb, its preferable to use that.
> Perhaps x86 can do something with running_clock?

Marcello?  Drew?

Cheers,
Don

> 
> Regards,
> 
> Cyril
> 
> > Cheers,
> > Don
> > 
> > > 
> > > > Not sure if that is useful or could be incoporated into the power8 code.
> > > > Though to be honest I am curious if the steal_time code could be ported to
> > > > your solution as it seems the watchdog code could remove all the
> > > > steal_time warts.
> > > Happy to help sus out the situation here, again, if you could pass on
> > > what the x86 guys are working on, thanks.
> > > 
> > > 
> > > Thanks,
> > > 
> > > Cyril
> > > > I have cc'd Marcelo into this discussion as he was the last person I
> > > > remember talking with about this problem.
> > > > 
> > > > Cheers,
> > > > Don
> > > 
> > > 
> 
> 
> 
