Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3KYRM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:12:57 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42513 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754021Ab3KYRMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:12:55 -0500
Message-ID: <52938514.60007@hurleysoftware.com>
Date: Mon, 25 Nov 2013 12:12:52 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] n_tty: Protect minimum_to_wake reset for concurrent readers
References: <1383850917-24416-1-git-send-email-peter@hurleysoftware.com> <20131125163602.GA19071@kroah.com>
In-Reply-To: <20131125163602.GA19071@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 11:36 AM, Greg Kroah-Hartman wrote:
> On Thu, Nov 07, 2013 at 02:01:57PM -0500, Peter Hurley wrote:
>> With multiple, concurrent readers (each waiting to acquire the
>> atomic_read_lock mutex), a departing reader may mistakenly reset
>> minimum_to_wake after a new reader has already set a new value.
>>
>> Protect the minimum_to_wake reset with the atomic_read_lock critical
>> section.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/tty/n_tty.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> This patch doesn't apply to Linus's tree anymore (and hence, mine.)  Is
> it needed for 3.13-final?  Or just 3.14-rc1?  Either way, can you
> refresh it and resend?

Hmmm, for me this applies cleanly to your tty-linus branch:

peter@thor:~/src/kernels/tty$ git tree -10
* c7df628 (HEAD, tty-linus) n_tty: Protect minimum_to_wake reset for concurrent readers
* 3dcf344 (origin/tty-linus) TTY: amiserial, add missing platform check
* dc1dc2f TTY: pmac_zilog, check existence of ports in pmz_console_init()
* c284ee2 n_gsm: race between ld close and gsmtty open
* f301412 tty/serial/8250: fix typo in help text
* c77569d n_tty: Fix 4096-byte canonical reads
* 6f22253 n_tty: Fix echo overrun tail computation
* 42458f4 n_tty: Ensure reader restarts worker for next reader
* 6ce4eac (tag: v3.13-rc1, origin/tty-next, origin/master, origin/HEAD) Linux 3.13-rc1

I'll just resend it.

Regards,
Peter Hurley
