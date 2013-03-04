Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab3CDRCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:02:06 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57382 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab3CDRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:02:05 -0500
Date: Mon, 4 Mar 2013 09:01:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Lianwei Wang <lianwei.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PATCH: freezer: add fake signal clearing back when thaw task
Message-ID: <20130304170159.GA30413@htj.dyndns.org>
References: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com>
 <20130225235313.GE2679@htj.dyndns.org>
 <CAJFUiJjy-7sS9xH76XMLs5SU6fUQ1Bk4Xn67jjHeZNQRjC54dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFUiJjy-7sS9xH76XMLs5SU6fUQ1Bk4Xn67jjHeZNQRjC54dg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 04, 2013 at 11:24:06AM +0800, Lianwei Wang wrote:
> Freeze/Thaw is a hot path for the Linux based mobile OS, e.g. Android.
> If we don't remove the pending fake signal, then the user space apps

Hotness is relative.  How often are we talking about?  Do you have any
numbers backing up that this actually makes any difference?  The
reason why I'm not convinced is that by the time the control reaches
fake_signal_clear() the system already has done most of the heavy
lifting and the code path which would be excluded by the extra
checking seems pretty short.  If you can show otherwise, please do so.

> or the related kernel driver has to handle such error. And yes, the
> user can handle such case by checking the return value, but it mislead
> the user and confuse to them that why wait_event_freezable and friends
> return a error on resume path every time? Can we avoid such useless
> error return?

-ERESTARTSYS may happen without freezing and the syscall path has been
capable of handling it for a very long time.  Again, do you have
anything which shows otherwise?

Thanks.

-- 
tejun
