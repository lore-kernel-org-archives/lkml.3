Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3FOLFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:05:15 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37099 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3FOLFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:05:11 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/6] ldsem patchset, reordered and rebased
Date: Sat, 15 Jun 2013 07:04:45 -0400
Message-Id: <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130603192436.GB22733@kroah.com>
References: <20130603192436.GB22733@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 03:24 PM, Greg Kroah-Hartman wrote:> On Mon, May 20, 2013 at 07:38:57PM -0400, Peter Hurley wrote:
>> On 05/20/2013 07:06 PM, Greg Kroah-Hartman wrote:
>>> On Mon, May 20, 2013 at 05:44:00PM -0400, Peter Hurley wrote:
>>>> On 05/20/2013 03:34 PM, Greg Kroah-Hartman wrote:
>>>>> On Tue, Apr 16, 2013 at 06:15:51AM -0400, Peter Hurley wrote:
>>>>>> Just as the tty pair must be locked in a stable sequence
>>>>>> (ie, independent of which is consider the 'other' tty), so must
>>>>>> the ldisc pair be locked in a stable sequence as well.
>>>>>>
>>>>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>>>>>> ---
>>>>>>   drivers/tty/tty_ldisc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>   1 file changed, 87 insertions(+)
>>>>>
>>>>> This patch breaks the build :(
>>>>
>>>> Sorry about that.
>>>>
>>>>> I've taken the first one, care to mush this one with the 7/7 patch, so
>>>>> there are no build breaks, and resend the 5 resulting patches so I can
>>>>> apply these?
>>>>
>>>> Maybe it would be better to reorder 7/7 to be 1/6, if that's ok?
>>>> More work for me but the history will be cleaner.
>>>
>>> Sure, that works for me as well, care to just resend them?  Or, I can
>>> dig them out of my archive if needed.
>>
>> I'll resend them because the rebase will require some re-editing.
> 
> Did you ever resend these?  If so, I didn't see them :(

Greg,

Sorry for the delay here. In addition to the re-editing required,
I merged in a couple of fixes and these needed re-testing.

These apply cleanly to tty-next.

Changes from previous 7-patch series:
1. In tty_ldisc_ref(), snapshot tty->ldisc holding ldsem.
   The conditions for this to be a fix cannot actually occur but
   this is better anyway.
2. In tty_set_ldisc(), the new ldisc needs to be released if
   tty_ldisc_lock_pair_timeout() fails.

Regards,
Peter Hurley

Peter Hurley (6):
  tty: Fix tty_ldisc_lock name collision
  tty: Add lock/unlock ldisc pair functions
  tty: Replace ldisc locking with ldisc_sem
  tty: Clarify ldisc variable
  tty: Fix hangup race with TIOCSETD ioctl
  tty: Clarify multiple-references comment in TIOCSETD ioctl

 drivers/tty/tty_buffer.c  |   2 +-
 drivers/tty/tty_io.c      |  11 +-
 drivers/tty/tty_ldisc.c   | 450 ++++++++++++++++------------------------------
 include/linux/tty.h       |   4 +-
 include/linux/tty_ldisc.h |   3 +-
 5 files changed, 158 insertions(+), 312 deletions(-)

-- 
1.8.1.2

