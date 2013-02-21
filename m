Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3BUFLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:11:48 -0500
Received: from relay.parallels.com ([195.214.232.42]:56107 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3BUFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:11:46 -0500
Message-ID: <5125AC65.7020006@parallels.com>
Date: Thu, 21 Feb 2013 09:11:01 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: general protection fault in do_msgrcv  [3.8]
References: <20130219180441.GA27141@redhat.com> <512487FA.9090102@parallels.com> <20130220182432.GA32377@redhat.com>
In-Reply-To: <20130220182432.GA32377@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.02.2013 22:24, Dave Jones пишет:
> On Wed, Feb 20, 2013 at 12:23:22PM +0400, Stanislav Kinsbursky wrote:
>
>   > > Pid: 887, comm: trinity-child2 Not tainted 3.8.0+ #57 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
>   > > RIP: 0010:[<ffffffff812aebba>]  [<ffffffff812aebba>] do_msgrcv+0x22a/0x670
>   > > ...
>   > > Looks like Stanislav recently changed this code, so problem was likely introduced
>   > > in those changes.
>   > >
>   >
>   > Is it easy to reproduce? Do you use KVM?
>
> Only hit it once so far, no KVM
>
>   > There is a NULL selinux handler bug fix by Stephen Smalley here:
>   > https://lkml.org/lkml/2013/2/6/663
>   >
>   > But anyway, this bug fix affects only the case, when MSG_COPY flag is set.
>   >
>   > And this is not your case, I suppose?
>
>  From my reading of the traces, I'd say not. It looks like I'm oopsing before
> we even get to the SELinux hooks.
>

Thanks, Dave. I've seen a couple of issues when running trinity in KVM somewhere in the same place.
Look like message queue itself has been destroyed somewhere in the past.
Have no idea how this can happen yet but still searching and will inform you in case of any fixes.

> 	Dave
>


-- 
Best regards,
Stanislav Kinsbursky
