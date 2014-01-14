Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaANQYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:24:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANQYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:24:18 -0500
Date: Tue, 14 Jan 2014 11:24:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Dave Young <dyoung@redhat.com>
Cc: wim@iguana.be, dzickus@redhat.com, bhe@redhat.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140114162405.GG3096@redhat.com>
References: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
 <20140114121639.77fe75ec@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114121639.77fe75ec@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 12:16:39PM +0000, One Thousand Gnomes wrote:
> On Tue, 14 Jan 2014 16:23:23 +0800
> Dave Young <dyoung@redhat.com> wrote:
> 
> > In kdump kernel watchdog could interrupt vmcore capturing because we
> > have no way to disable/stop it while crashing happens.
> 
> Lots of watchdogs cannot be stopped.
> 
> > Add a module parameter stop_before_register so watchdog can be stopped
> > before register in driver loading path. Thus we can try to load the
> > watchdog driver as early as possible in kdump kernel to ensure vmcore
> > capturing.
> 
> If you want to kdump then don't start the watchdog. The goal of the
> watchdog is to make sure the system never gets stuck. Adding conditions
> and special cases simply increases the odds of something bad not
> triggering the watchdog.
> 
> If you have a system that can stop the watchdog then providing no way out
> is not set you can open it and stop it.
> 
> I don't see the need for any kernel change here
> 
> - if it can't be stopped you lost
> - if "nowayout" is set then by design you lost
> - if it can be stopped, you can open and stop it
> 
> Now whether in the !nowayout case the watchdog core should catch whatever
> hooks/notifiers are available and stop any watchdogs it can on a
> kexec/kdump is a more interesting question and probably needs to default
> to not doing so but with the option to force otherwise for debugging work.

Hi All,

I thought this problem was resolved (atleast conceptually) last time
when Don Zickus brought it up.

He mentioned that it was concluded that keep watchdog interval long
enough, say 60 seconds and keep on kicking it fast enough, say every
10-20 seconds. That would ensure that after the crash, there is atleast
60 - 20 = 40 seconds left before watchdog expires. And in that duration
we should try to boot into second kernel load watchdog driver early enough
from initramfs which can start kicking watchdog again.

I am wondering what happened to this idea. Dave, did we try to implement/
experiment with this?

Thanks
Vivek
