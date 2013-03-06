Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3CFDLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:11:16 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:47100 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3CFDLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:11:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130306011623.GG1227@htj.dyndns.org>
References: <20130304092310.1d21100c@tlielax.poochiereds.net>
	<CACBanvrc0orXGZ1v+gKHtVPKWYKGEFx46dwoDCjTU78+nPtZyg@mail.gmail.com>
	<20130304205307.GA13527@redhat.com>
	<4FA345DA4F4AE44899BD2B03EEEC2FA9286AEEB0@sacexcmbx05-prd.hq.netapp.com>
	<20130305082308.6607d4db@tlielax.poochiereds.net>
	<20130305174648.GF12795@htj.dyndns.org>
	<20130305174954.GG12795@htj.dyndns.org>
	<20130305231110.GK15816@fieldses.org>
	<CACBanvo+JDCFVRQeTQwnwRRxr8bdqxdsgeEr8fqgJhGQJEEQ-Q@mail.gmail.com>
	<20130306010507.GL15816@fieldses.org>
	<20130306011623.GG1227@htj.dyndns.org>
Date: Tue, 5 Mar 2013 19:11:12 -0800
X-Google-Sender-Auth: QflGWwoVdY83BLSK8rS7dB4XXqA
Message-ID: <CACBanvqVpi45TVNGXgXXO0BCSRuPEDsiNuHj0OBsvgr2UXZfsg@mail.gmail.com>
Subject: Re: LOCKDEP: 3.9-rc1: mount.nfs/4272 still has locks held!
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Oleg Nesterov <oleg@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 5:16 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 05, 2013 at 08:05:07PM -0500, J. Bruce Fields wrote:
>> If it's really just a 2-line patch to try_to_freeze(), could it just be
>> carried out-of-tree by people that are specifically working on tracking
>> down these problems?
>>
>> But I don't have strong feelings about it--as long as it doesn't result
>> in the same known issues getting reported again and again....
>
> Agreed, I don't think a Kconfig option is justified for this.  If this
> is really important, annotate broken paths so that it doesn't trigger
> spuriously; otherwise, please just remove it.
>

Fair enough. Let's revert then. I'll rework to use a lockdep annotation.

Maybe, add a new lockdep API:

lockdep_set_held_during_freeze(lock);

Then when we do the check, ignore any locks that set this bit.

Ingo, does this seem like a reasonable design to you?

Regards,
Mandeep

> Thanks.
>
> --
> tejun
