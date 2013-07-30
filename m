Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3G3FuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:50:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:46550 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3G3FuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:50:16 -0400
Date: Tue, 30 Jul 2013 13:49:55 +0800
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130730054955.GA5225@kernel.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
 <20130729125259.GA9306@kernel.org>
 <20130729153523.GA22605@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729153523.GA22605@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 11:35:23AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jul 29, 2013 at 08:52:59PM +0800, Shaohua Li wrote:
> > Ah, ok, I thought it's straightforward... It's a bug fix.
> 
> It never is, seriously.  If it's something trivial / straighforward,
> please say so in the patch description because not doing so forces
> other people to guess the intention behind the change which sucks and
> this isn't even that trivial.
> 
> > echo '0' > /sys/bus/workqueue/devices/xxx/numa
> > cat /sys/bus/workqueue/devices/xxx/numa
> > I got 1. It should be 0, the reason is copy_workqueue_attrs() called in
> > apply_workqueue_attrs() doesn't copy no_numa field.
> 
> Note that copy_workqueue_attrs() is also used while creating worker
> pools and this change would mean that there will be worker pools with
> no_numa attribute assigned basically randomly depending on which wq
> created the pool for the first time which should be fine AFAICS but
> isn't very nice.  Given that there's only single place where a pool's
> attrs is set, maybe it'd be best to clear no_numa right after copy and
> explain what's going on there?

alloc_workqueue_attrs() always zero the new allocated attr.

Thanks,
Shaohua
