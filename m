Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3LQBYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:24:46 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38760 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752434Ab3LQBYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:24:45 -0500
Message-ID: <52AFA7CF.3050800@hurleysoftware.com>
Date: Mon, 16 Dec 2013 20:24:31 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Stas Sergeev <stsp@list.ru>,
        Margarita Manterola <margamanterola@gmail.com>,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Caylan Van Larson <i@caylan.net>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Pavel Machek <pavel@ucw.cz>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: [PATCH v4] n_tty: Fix buffer overruns with larger-than-4k pastes
References: <52A79030.9090403@hurleysoftware.com> <1386713522-6959-1-git-send-email-peter@hurleysoftware.com> <20131217005719.GA26381@kroah.com>
In-Reply-To: <20131217005719.GA26381@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 07:57 PM, Greg Kroah-Hartman wrote:
> On Tue, Dec 10, 2013 at 05:12:02PM -0500, Peter Hurley wrote:
>> readline() inadvertently triggers an error recovery path when
>> pastes larger than 4k overrun the line discipline buffer. The
>> error recovery path discards input when the line discipline buffer
>> is full and operating in canonical mode and no newline has been
>> received. Because readline() changes the termios to non-canonical
>> mode to read the line char-by-char, the line discipline buffer
>> can become full, and then when readline() restores termios back
>> to canonical mode for the caller, the now-full line discipline
>> buffer triggers the error recovery.
>>
>> When changing termios from non-canon to canon mode and the read
>> buffer contains data, simulate an EOF push _without_ the
>> DISABLED_CHAR in the read buffer.
>>
>> Importantly for the readline() problem, the termios can be
>> changed back to non-canonical mode without changes to the read
>> buffer occurring; ie., as if the previous termios change had not
>> happened (as long as no intervening read took place).
>>
>> Preserve existing userspace behavior which allows '\0's already
>> received in non-canon mode to be read as '\0's in canon mode
>> (rather than trigger add'l EOF pushes or an actual EOF).
>>
>> Patch based on original proposal and discussion here
>> https://bugzilla.kernel.org/show_bug.cgi?id=55991
>> by Stas Sergeev <stsp@users.sourceforge.net>
>>
>> Reported-by: Margarita Manterola <margamanterola@gmail.com>
>> Cc: Maximiliano Curia <maxy@gnuservers.com.ar>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
>> Acked-by: Stas Sergeev <stsp@users.sourceforge.net>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>
> Is this a 3.13-final thing, or can it wait for 3.14-rc1?

Definitely not 3.13 at this point -- it should go to -next.

Regards,
Peter Hurley

