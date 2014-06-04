Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaFDOsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:48:40 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42004 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752182AbaFDOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:48:38 -0400
Message-ID: <538F31C5.3090901@hurleysoftware.com>
Date: Wed, 04 Jun 2014 10:48:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] serial: core: Preserve termios c_cflag for console
 resume
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it> <1401891371-4946-1-git-send-email-peter@hurleysoftware.com> <1401891371-4946-2-git-send-email-peter@hurleysoftware.com> <20140604142232.GB1008@kroah.com> <538F3150.6040102@hurleysoftware.com>
In-Reply-To: <538F3150.6040102@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 10:46 AM, Peter Hurley wrote:
> On 06/04/2014 10:22 AM, Greg Kroah-Hartman wrote:
>> On Wed, Jun 04, 2014 at 10:16:11AM -0400, Peter Hurley wrote:
>>> When a tty is opened for the serial console, the termios c_cflag
>>> settings are inherited from the console line settings.
>>> However, if the tty is subsequently closed, the termios settings
>>> are lost. This results in a garbled console if the console is later
>>> suspended and resumed.
>>>
>>> Preserve the termios c_cflag for the serial console when the tty
>>> is shutdown; this reflects the most recent line settings.
>>>
>>> Fixes: Bugzilla #69751, 'serial console does not wake from S3'
>>> Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
>>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>>> ---
>>>   drivers/tty/serial/serial_core.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>
>> Same as before, regression, or just a normal "new feature"?
>
> This was reported as a regression since 2.6.24, but that was likely
> misreported, and more likely due to a userspace update which triggers
> the bug.
>
> I would be surprised if console resume _never_ worked if the serial tty
> was opened then closed, but it probably has worked for a long time.
                                          ^^^^^
                                          hasn't

