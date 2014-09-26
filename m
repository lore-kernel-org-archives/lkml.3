Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaIZEwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:52:17 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:44243 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaIZEwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140926031151.GB40523@vmdeb7>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
	<1411518268-2773-4-git-send-email-coproscefalo@gmail.com>
	<20140926031151.GB40523@vmdeb7>
Date: Thu, 25 Sep 2014 22:52:15 -0600
Message-ID: <CAGdLNWEwkNxnebpTNz3bccLdJNSyuthPfB7ZSR5oYgKDLScsqg@mail.gmail.com>
Subject: Re: [PATCH 3/4] toshiba_acpi: Change HCI/SCI functions return code type
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-25 21:11 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> On Tue, Sep 23, 2014 at 06:24:27PM -0600, Azael Avalos wrote:
>> Currently the HCI/SCI read/write functions are returning
>> the status of the ACPI call and also assigning the
>> returned value of the HCI/SCI function.
>>
>> This patch changes such functions, returning the value
>> of the HCI/SCI function instead of the ACPI call status.
>>
>> The next patch will change all the HCI/SCI functions
>> to reflect the change made in this patch.
>
> If you are changing what the functions return in this patch, you also need to
> update the call sites at the same time (same patch).

Ok

>
>>
>> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
>> ---
>>  drivers/platform/x86/toshiba_acpi.c | 51 ++++++++++++++++++++-----------------
>>  1 file changed, 27 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
>> index 5b16d11..43385f7 100644
>> --- a/drivers/platform/x86/toshiba_acpi.c
>> +++ b/drivers/platform/x86/toshiba_acpi.c
>> @@ -316,47 +316,49 @@ static acpi_status tci_raw(struct toshiba_acpi_dev *dev,
>>   * may be useful (such as "not supported").
>>   */
>
> The full text of the comment above is:
>
> /* common hci tasks (get or set one or two value)
>  *
>  * In addition to the ACPI status, the HCI system returns a result which
>  * may be useful (such as "not supported").
>  */
>
> Is this no longer relevant?

On the contrary, the "result" parameter is the one being returned by the
modified read/write functions now, and was (and still is) the only one
being checked for support, error, or otherwise, depending on what the
Toshiba method returns.

>
> I agree that the return and status approach seems suboptimal, but I'm not clear on the motivation for the change. Is there something besides cleanup you're attempting to work toward with this series?

Cleanup mostly, what's the purpose of returning a value,
if that value is never checked? Better return a value that
indeed is being checked, and contains useful info about
the status of the queried function (such as "not supported")
:-)


>
> --
> Darren Hart
> Intel Open Source Technology Center

Cheers
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
