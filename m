Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3A3KZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:25:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45076 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3A3KZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:25:23 -0500
MIME-Version: 1.0
In-Reply-To: <s5hpq0nw35i.wl%tiwai@suse.de>
References: <1359470814-7993-1-git-send-email-tiwai@suse.de>
	<1359470814-7993-2-git-send-email-tiwai@suse.de>
	<CACVXFVOf4LZD+qVcqS9yBtvNZCRF=LMpR5BKuXby3Z8dfB+Vzw@mail.gmail.com>
	<s5hpq0nw35i.wl%tiwai@suse.de>
Date: Wed, 30 Jan 2013 18:25:20 +0800
Message-ID: <CACVXFVN9JNe6US655hh3cNpKyJFdWrLEYOOOdnk97_5bFmZYxw@mail.gmail.com>
Subject: Re: [PATCH 1/4] firmware: Refactoring for splitting user-mode helper code
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 3:17 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> The above usermodehelper_read_lock thing may be a functional change,
>> and looks not what you claimed in commit log, :-). The lock is currently held in
>> direct loading case, but your patch change the rule. Without holding the lock,
>> request_firmware() may touch filesystem / storage too early during
>> kernel boot or system resume in direct loading case.
>
> Does it really happen in a real scenario?

Some crazy drivers might call request_firmware inside resume callback,
with usermodehelper_read_lock, we can find the mistake easily and log it.

>
> If so, using usermode helper lock for that purpose sounds like an
> abuse to be fixed differently or replaced with a better one.

Might be, but looks not good to introduce this change in a code
refactoring patch. Or you can do it in another patch for discussion
if you have better way to handle the situation.


Thanks,
--
Ming Lei
