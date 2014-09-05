Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaIEHLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:11:54 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38488 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaIEHLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
Date: Fri, 5 Sep 2014 16:11:50 +0900
X-Google-Sender-Auth: 3YCdo0vpo9ZfjQuTM7SIl2TDw4c
Message-ID: <CAOS58YPxAkziZ4CT2GhoCQsMcFJ9R-Q2FutY8GG=S20pvix0ow@mail.gmail.com>
Subject: Re: [RFC v2 0/6] driver-core: add asynch probe support
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, falcon@meizu.com,
        Takashi Iwai <tiwai@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        hare@suse.com, Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>, bpoirier@suse.de,
        santosh@chelsio.com, "Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 04, 2014 at 11:37:21PM -0700, Luis R. Rodriguez wrote:
> Tejun's concerns on this regressing some driver's scripts which expect
> the device to be available after loading remains valid, and the only
> thing we can do to help there is to annotate the expecations on the
> use of this "feature" to driver users. Scripts should be not be relying
> on the driver init anyway so that type of usage should be phased out
> and they should be hunting in udev for things popping up.

Ummm... I really don't think we can say that.  This was one of the
supported ways to wait for the probing of pre-existing devices on
driver load.  We can't simply go and declare that "scripts should not
be relying on the driver init anyway".  We just can't do that.

> I'm a bit concerned about this actually regressing load time on
> drivers that use this though instead of just having the module
> probe run off of finit_module() though. Even with a kthread alternative
> at least Santosh (Cc'd) has noted a regression in terms of time it
> takes to complete probe on cxgb4. I'll eventually get your exact
> numbers, but for now its an obvious regression *with* kthreads,
> this solution goes with:
>
> queue_work(system_unbound_wq, async_probe_work)
>
> This is surely going to make things even worse... We could
> use system_highpri_wq, or change the scheduling priority, but
> for that I'd prefer to get feedback and someone to decide what
> the right choice (TM) should be.

It shouldn't add any noticeable delays in probing.  If it does, we
should track down why that's happening and fix it.

Thanks.

-- 
tejun
