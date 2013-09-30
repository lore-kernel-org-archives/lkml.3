Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3I3A4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:56:21 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60665 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3I3A4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:56:19 -0400
Message-ID: <5248CC2D.1080000@gmail.com>
Date: Mon, 30 Sep 2013 10:56:13 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
CC: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        eldad@fogrefinery.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Check real user/group id for %pK
References: <20130929234146.31004.qmail@science.horizon.com> <5248C8A1.3090302@gmail.com>
In-Reply-To: <5248C8A1.3090302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/13 10:41, Dan Rosenberg wrote:
> On 09/29/2013 07:41 PM, George Spelvin wrote:
>>> Right, so the pppd application is actually doing the correct thing.
>> And a CAP_SYSLOG setuid binary that *doesn't* DTRT seems like a more
>> immediate security hole than leaking kernel addresses.  After all
>> kptr_restrict is optional precisely because the benefit is marginal.
>>
>> The interesting question is what credentials make sense for %pK outside
>> of a seq_printf().  Does it even make sense in a generic printk?  In that
>> case, it's the permission of the syslogd that matters rather than the
>> process generating the message.
>>
>>> Will wait and see what others have to say.
>> Me, too.  Dan in particular.
> 
> Firstly, I wouldn't recommend applying %pK's to printk usage.

Sorry, the patch description should say 'vsprintf: ' not 'printk: '.
Posting too early in the morning :-).

> Removing
> all addresses from the kernel syslog compromises its usefulness in
> debugging basically anything at all. Additionally, many printk calls are
> performed from a context where a capability check would yield
> unpredictable (or at least meaningless) results. If you want to restrict
> access to the kernel syslog by unprivileged users, that should be done
> by enabling CONFIG_DMESG_RESTRICT, which was written for this purpose.

Agreed.

> With that out of the way, I don't have a strong opinion on how to handle
> this case. The proposed patch solves the problem but may break setuid
> applications that expect to be able to read /proc/kallsyms contents
> based on euid (and implicitly, capabilities) alone. But then again,
> these mythical setuid applications are probably broken in some
> situations anyway, because what happens if /proc/kallsyms is set to "2"
> (unconditionally replace addresses with 0's)? I also can't think of a
> better solution.

Okay, this was just the simplest solution I could come up with that
fixed the issue for me. Is that a tentative acked/reviewed-by? :-).

~Ryan


