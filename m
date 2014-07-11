Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaGKPDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:03:24 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53205 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbaGKPDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:03:20 -0400
Message-ID: <53BFFCB0.5020400@hurleysoftware.com>
Date: Fri, 11 Jul 2014 11:03:12 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Karsten Keil <isdn@linux-pingi.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH tty-next 14/22] tty: Remove tty_wait_until_sent_from_close()
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com> <1402924639-5164-15-git-send-email-peter@hurleysoftware.com> <20140710230936.GA31181@kroah.com>
In-Reply-To: <20140710230936.GA31181@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 07:09 PM, Greg Kroah-Hartman wrote:
> On Mon, Jun 16, 2014 at 09:17:11AM -0400, Peter Hurley wrote:
>> tty_wait_until_sent_from_close() drops the tty lock while waiting
>> for the tty driver to finish sending previously accepted data (ie.,
>> data remaining in its write buffer and transmit fifo).
>>
>> However, dropping the tty lock is a hold-over from when the tty
>> lock was system-wide; ie., one lock for all ttys.
>>
>> Since commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01,
>> 'tty: localise the lock', dropping the tty lock has not been necessary.
>>
>> CC: Karsten Keil <isdn@linux-pingi.de>
>> CC: linuxppc-dev@lists.ozlabs.org
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/isdn/i4l/isdn_tty.c   |  2 +-
>>   drivers/tty/hvc/hvc_console.c |  2 +-
>>   drivers/tty/hvc/hvcs.c        |  2 +-
>>   drivers/tty/tty_port.c        | 11 ++---------
>>   include/linux/tty.h           | 18 ------------------
>>   5 files changed, 5 insertions(+), 30 deletions(-)
>
> I've applied the first 13 patches in this series, as it looks like you
> were going to split things up from here, right?

Yes, thanks for doing that.

> Can you refresh these and resend when you have that done?

Unfortunately, that probably won't be until after the 3.17 merge window,
for 3.18. The tty_open() rework is not trivial and there is an issue
with the ldisc flush removal patch.

I'm hoping to include the tty flow control fixes with that stuff as well.

Regards,
Peter Hurley
