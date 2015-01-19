Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbbASJ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:59:18 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39781 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbASJ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:59:17 -0500
Message-ID: <54BCD572.7060203@suse.cz>
Date: Mon, 19 Jan 2015 10:59:14 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/3] sound: dummy, use del_timer_sync
References: <1421660576-8435-1-git-send-email-jslaby@suse.cz>	<1421660576-8435-2-git-send-email-jslaby@suse.cz> <s5hvbk3qeq9.wl-tiwai@suse.de>
In-Reply-To: <s5hvbk3qeq9.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015, 10:52 AM, Takashi Iwai wrote:
> At Mon, 19 Jan 2015 10:42:55 +0100,
> Jiri Slaby wrote:
>>
>> Wait for the timer to really quit, not only by ensuring it is not in
>> the critical section.
>>
>> BTW the spin_lock in here does not disable BH, so that it could
>> deadlock.
> 
> The stop function is called from the PCM trigger callback which is
> irq-disabled.  So, you can't use del_timer_sync() here.

The same as 3/3 I was looking at compr* :(. Ignore this one, then.

thanks,
-- 
js
suse labs
