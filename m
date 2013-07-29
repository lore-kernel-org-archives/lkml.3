Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3G2MxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:53:11 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63275 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3G2MxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:53:08 -0400
Date: Mon, 29 Jul 2013 20:52:59 +0800
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130729125259.GA9306@kernel.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729111401.GA20951@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 07:14:01AM -0400, Tejun Heo wrote:
> Hello, Shaohua.
> 
> On Mon, Jul 29, 2013 at 02:24:12PM +0800, Shaohua Li wrote:
> > copy_workqueue_attrs() forgets to copy no_numa field.
> 
> Explaining how that affects things and how the behavior changes
> afterwards would be nice.  As it currently stands, I don't know why
> you're submitting this patch.  Is this a bug fix?  Just a consistency
> update?  Should it be marked with -stable?
> 
> Please put more effort into patch descriptions and also note that
> ->no_numa isn't a pool attribute as noted in the comment above struct
> workqueue_attrs definition.

Ah, ok, I thought it's straightforward... It's a bug fix.
echo '0' > /sys/bus/workqueue/devices/xxx/numa
cat /sys/bus/workqueue/devices/xxx/numa
I got 1. It should be 0, the reason is copy_workqueue_attrs() called in
apply_workqueue_attrs() doesn't copy no_numa field.

Thanks,
Shaohua
