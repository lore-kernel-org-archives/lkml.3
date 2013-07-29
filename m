Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3G2Pfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:35:32 -0400
Received: from mail-gh0-f182.google.com ([209.85.160.182]:43620 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3G2Pf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:35:28 -0400
Date: Mon, 29 Jul 2013 11:35:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130729153523.GA22605@mtj.dyndns.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
 <20130729125259.GA9306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729125259.GA9306@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 29, 2013 at 08:52:59PM +0800, Shaohua Li wrote:
> Ah, ok, I thought it's straightforward... It's a bug fix.

It never is, seriously.  If it's something trivial / straighforward,
please say so in the patch description because not doing so forces
other people to guess the intention behind the change which sucks and
this isn't even that trivial.

> echo '0' > /sys/bus/workqueue/devices/xxx/numa
> cat /sys/bus/workqueue/devices/xxx/numa
> I got 1. It should be 0, the reason is copy_workqueue_attrs() called in
> apply_workqueue_attrs() doesn't copy no_numa field.

Note that copy_workqueue_attrs() is also used while creating worker
pools and this change would mean that there will be worker pools with
no_numa attribute assigned basically randomly depending on which wq
created the pool for the first time which should be fine AFAICS but
isn't very nice.  Given that there's only single place where a pool's
attrs is set, maybe it'd be best to clear no_numa right after copy and
explain what's going on there?

Thanks.

-- 
tejun
