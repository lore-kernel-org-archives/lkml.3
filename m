Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3LLUg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:36:59 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59573 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621Ab3LLUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:36:56 -0500
Message-ID: <52AA1E62.1030109@hurleysoftware.com>
Date: Thu, 12 Dec 2013 15:36:50 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>,
        Gustavo Padovan <gustavo@padovan.org>,
        Gianluca Anzolin <gianluca@sottospazio.it>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, gregkh@linuxfoundation.org,
        jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
References: <1377620926-23370-1-git-send-email-gianluca@sottospazio.it> <20130919162413.GG4006@joana> <52AA1854.500@ahsoftware.de>
In-Reply-To: <52AA1854.500@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 03:11 PM, Alexander Holler wrote:
> Hello,
>
> since commit 29cd718beba999bda4bdbbf59b5a4d25c07e1547 "rfcomm: don't release the port in rfcomm_dev_state_change()" the userland utility rfcomm (both from bluez 4.101 and 5.12) is broken.
>
> In detail the following note in the patch
>
> Am 19.09.2013 18:24, schrieb Gustavo Padovan:
>> Hi Gianluca,
>>
>> 2013-08-27 Gianluca Anzolin <gianluca@sottospazio.it>:
>>
>>> When the dlc is closed, rfcomm_dev_state_change() tries to release the
>>> port in the case it cannot get a reference to the tty. However this is
>>> racy and not even needed.
>>>
>>> Infact as Peter Hurley points out:
>
> (...)
>
>>> 4. After releasing the dlc lock in rfcomm_dev_add(),
>>>     rfcomm_dev_state_change() will 'see' an incomplete rfcomm_dev if a
>>>     tty reference could not be obtained. Again, the best thing to do here
>>>     is nothing. Any future attempted open() will block on
>>>     rfcomm_dev_carrier_raised(). The unconnected device will exist until
>>>     released by ioctl(RFCOMMRELEASEDEV).
>>>
>>> The patch removes the aforementioned code and uses the
>>> tty_port_tty_hangup() helper to hangup the tty.
>
> reads like the usage of that ioctl now necessary.
>
> What currently happens is that when one kills rfcomm (and any other terminal which might use that tty), the entry in /dev doesn't disappear. That means the same call to refcomm with the same device (e.g. [/dev/]rfcomm1 doesn't work.

Thanks for the report, Alexander.

Point 4 above details a different situation; something else is
happening.

Would you please detail the necessary steps to reproduce this regression?
(How do you 'kill' rfcomm? etc.  Shell command lines would be best.)

> My current solution is to just revert that commit.
> I haven't tested if modifying (the userland utility) rfcomm (adding that ioctl) will help, but that looks only like a longterm solution.

Changes to userspace should not be required; rfcomm should be
handling teardown without help.

Regards,
Peter Hurley

