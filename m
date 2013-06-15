Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3FOL2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:28:50 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37960 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3FOL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:28:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/4] [resend] n_tty fixes
Date: Sat, 15 Jun 2013 07:28:27 -0400
Message-Id: <1371295711-3963-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130319141017.GB24900@kroah.com>
References: <20130319141017.GB24900@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 10:10 AM, Greg Kroah-Hartman wrote:> On Tue, Mar 19, 2013 at 09:57:09AM -0400, Peter Hurley wrote:
>> On Mon, 2013-03-18 at 16:15 -0700, Greg Kroah-Hartman wrote:
>>> On Wed, Mar 06, 2013 at 08:38:22AM -0500, Peter Hurley wrote:
>>>> minimum_to_wake is unique to N_TTY processing, and belongs in
>>>> per-ldisc data.
>>>>
>>>> Add the ldisc method, ldisc_ops::fasync(), to notify line disciplines
>>>> when signal-driven I/O is enabled or disabled. When enabled for N_TTY
>>>> (by fcntl(F_SETFL, O_ASYNC)), blocking reader/polls will be woken
>>>> for any readable input. When disabled, blocking reader/polls are not
>>>> woken until the read buffer is full.
>>>>
>>>> Canonical mode (L_ICANON(tty), n_tty_data::icanon) is not affected by
>>>> the minimum_to_wake setting.
>>>>
>>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>>>
>>> For some reason, this patch doesn't apply.  Care to refresh this one,
>>> and the rest in this series, and resend?
>>
>> Sorry. There was probably some accidental dependency on one of the other
>> patchsets of mine you did apply.
>>
>> This and patch 5 now apply without error to tty-next.
> 
> Ok, but they are now long gone from my queue.  Can you please resend
> what I haven't applied?

Greg,

I resent these back on 19 Mar but they never got applied. (maybe because
I resent them as 4,5,6 & 7/7 ??)

Anyway, these apply cleanly to tty-next.

Regards,
Peter Hurley


Peter Hurley (4):
  n_tty: Encapsulate minimum_to_wake within N_TTY
  n_tty: Untangle read completion variables
  n_tty: Fix unsafe update of available buffer space
  n_tty: Buffer work should not reschedule itself

 drivers/tty/n_tty.c       | 76 ++++++++++++++++++++++++++++++-----------------
 drivers/tty/tty_io.c      | 17 ++++++-----
 include/linux/tty.h       |  1 -
 include/linux/tty_ldisc.h |  6 ++++
 4 files changed, 63 insertions(+), 37 deletions(-)

-- 
1.8.1.2

