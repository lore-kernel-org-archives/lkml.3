Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaKERKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:10:21 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53141 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755585AbaKERKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:10:17 -0500
Message-ID: <545A59F5.8000202@hurleysoftware.com>
Date: Wed, 05 Nov 2014 12:10:13 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] tty: serial: men_z135_uart: Fix driver for changes
 in hardware
References: <1415030753-26885-1-git-send-email-johannes.thumshirn@men.de> <5457ED0C.3090705@hurleysoftware.com> <5457F30F.2030203@hurleysoftware.com> <20141105163952.GA21159@jtlinux>
In-Reply-To: <20141105163952.GA21159@jtlinux>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 11:39 AM, Johannes Thumshirn wrote:
> On Mon, Nov 03, 2014 at 04:26:39PM -0500, Peter Hurley wrote:
>> On 11/03/2014 04:01 PM, Peter Hurley wrote:
>>> On 11/03/2014 11:05 AM, Johannes Thumshirn wrote:
>>>> * Enable the handling of UART core's automatic flow control feature.
>>>>   When AFE is active disable generation of modem status IRQs.
>>>
>>> So HUPCL doesn't work when CRTSCTS is set?
>>
>> Sorry, I meant !CLOCAL. IOW,
>>
>> 'So !CLOCAL doesn't work when CRTSCTS is set?'
> 
> Yes, unfortunately

Then you want to reset CLOCAL back on in the termios when
you enable auto flow control. That way, the process can see which
termios changes were successful and which were unsuccessful.
Plus, it keeps the serial core state sync'd with the driver.

Optionally, you could consider overriding CRTSCTS when !CLOCAL; iow,
if !CLOCAL, then disable CRTSCTS instead. (In that case, you would
reset CRTSCTS in the termios as well, so the process would be aware
of the changes).

>>
>>> Is this because there's actually a problem with the IP core that
>>> MSIs trash the autoCTS state, or is the problem that the driver
>>> just shouldn't be calling uart_handle_cts_change() when autoCTS is
>>> on?
>>
> 
> From our investigations it looks like it trashes the autoCTS state.

Ok.

Regards,
Peter Hurley
