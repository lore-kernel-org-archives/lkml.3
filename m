Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaAOA7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:59:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbaAOA7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:59:14 -0500
Date: Wed, 15 Jan 2014 08:59:31 +0800
From: Dave Young <dyoung@redhat.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: wim@iguana.be, dzickus@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140115005931.GB23767@dhcp-16-126.nay.redhat.com>
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

On 01/14/14 at 12:16pm, One Thousand Gnomes wrote:
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

watchdog and crash dump really conflicts to some degree, from the watchdog
point of view it can reboot system whhen kdump kernel hangs. But from kdump
point of view it want ensure saving the vmcore for later debugging.

Maybe we can only select only one in this case.
> 
> If you have a system that can stop the watchdog then providing no way out
> is not set you can open it and stop it.
> 
> I don't see the need for any kernel change here
> 
> - if it can't be stopped you lost
> - if "nowayout" is set then by design you lost
> - if it can be stopped, you can open and stop it

For the last one since crashing happens we have no chance to open and stop.

> 
> Now whether in the !nowayout case the watchdog core should catch whatever
> hooks/notifiers are available and stop any watchdogs it can on a
> kexec/kdump is a more interesting question and probably needs to default
> to not doing so but with the option to force otherwise for debugging work.

Unfortunately in crash path there's no chance to do so. It's not good to
add more logic in that path as well.

Thanks
Dave
