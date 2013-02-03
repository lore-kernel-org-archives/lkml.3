Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3BCRCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:02:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:21358 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3BCRCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:02:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="286033282"
Date: Sun, 3 Feb 2013 18:01:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 09/26] mfd: ab8500-debugfs: Provide a means for a user
 subscribe to IRQs
Message-ID: <20130203170158.GO8476@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-10-git-send-email-lee.jones@linaro.org>
 <20130127235259.GO1174@sortiz-mobl>
 <20130128102223.GA18212@gmail.com>
 <20130128104933.GY1174@sortiz-mobl>
 <20130128113443.GB18212@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128113443.GB18212@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jan 28, 2013 at 11:34:43AM +0000, Lee Jones wrote:
> On Mon, 28 Jan 2013, Samuel Ortiz wrote:
> 
> > Hi Lee,
> > 
> > On Mon, Jan 28, 2013 at 10:22:23AM +0000, Lee Jones wrote:
> > > On Mon, 28 Jan 2013, Samuel Ortiz wrote:
> > > 
> > > > Hi Lee,
> > > > 
> > > > On Tue, Jan 15, 2013 at 12:55:49PM +0000, Lee Jones wrote:
> > > > > Allow users to subscribe to and view IRQ events live from debugfs.
> > > > I seem to remember that I got a similar patch some time ago for the same
> > > > purpose and my answer was: Please use a UIO driver for this. There already is
> > > > such driver, it's uio_pdrv_genirq. What your debugfs registration entry could
> > > > do is adding a platform device for the specific interrupt number. This would
> > > > avoid the irq handler registration and the sysfs entry creation, both things I
> > > > believe are not very elegant and open coded. It also gives you an IRQ count
> > > > implementation.
> > > > Ideally, the UIO framework could be improved to support IRQ ranges (through
> > > > IRQ domains) instead of the current single interrupt number.
> > > > 
> > > > Have you considered going through that path ?
> > > 
> > > I'm going to have to put this patch-set in the bin. Pulling this
> > > patch, causes lots of conflicts to the remaining patches in the
> > > set.
> > I bet removing this one causes a lot of conflicts. I'm not saying it should
> > absolutely be removed, but I'm afraid once it's upstream no one is going to
> > look at improving it.
> 
> This is really not the case. 
I trust you here, but usually people get busy with other stuff after their
patchset is upstreamed and never get back to me on the initial issues.

> I have every intention of fixing each and
> every issue which are brought to my attention during the upstreaming
> process of 'drivers/regulators', 'drivers/power' and 'drivers/mfd'.
> 
> All I'm doing is making a list of all the fixups and re-writes and
> I'll address them on the completion of the push. Hence if you're happy
> for this to go in with my promise of improvement, it would certainly
> make this task a great deal easier for me.
I'll take your words here. I'll apply this one once you adressed the other
issues I commented about on this patchset.


> > And to be honest, having an IRQ handler from debugfs
> > code looks weird to me. I know you can put all sort of crazyness into a
> > debugfs entry, but still.
> >  
> > > I'll start again from scratch and find another way to sync the ab* MFD
> > > drivers. I might even have to do it manually i.e. throw out all
> > > commit history and upstream it as my own patches pulled in from diffs.
> > I don't have any problems with that.
> 
> I'm sure you don't, but it's me that's doing all the hard work. ;)
What's wrong with that ? ;)

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
