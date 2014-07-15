Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbaGOXVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:21:34 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53020 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaGOXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:21:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140715152929.GA8844@kroah.com>
References: <20140715091144.GA19080@devel.8.8.4.4>
	<20140715152929.GA8844@kroah.com>
Date: Wed, 16 Jul 2014 08:21:30 +0900
Message-ID: <CAHb8M2B0EAjDr=yTfWQ_YsRcX9JumU8rUQ1mQeoqMWeBbY4gnQ@mail.gmail.com>
Subject: Re: [PATCH 6/8 V2] staging: dgap: remove unneeded dgap_err()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-07-16 0:29 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Jul 15, 2014 at 06:11:44PM +0900, Daeseok Youn wrote:
>> The dgap_err() is printing a message with pr_err(),
>> so all those are replaced.
>>
>> Use definition "pr_fmt" and then all of "dgap:" in
>> the beginning of print messages are removed.
>>
>> And also removed "out of memory" message because
>> the kernel has own message for that.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> V2: use pr_fmt "dgap:" prefix on print message on dgap.
>>     remove "out of memory" message.
>>
>>     Adds Mark to TO list and CC list for checking send
>>     this email properly to him.
>>
>>  drivers/staging/dgap/dgap.c |  306 +++++++++++++++++++------------------------
>>  1 files changed, 133 insertions(+), 173 deletions(-)
>>
>> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>> index 06c55cb..9e750fb 100644
>> --- a/drivers/staging/dgap/dgap.c
>> +++ b/drivers/staging/dgap/dgap.c
>> @@ -41,6 +41,8 @@
>>   */
>>  #undef DIGI_CONCENTRATORS_SUPPORTED
>>
>> +#define pr_fmt(fmt) "dgap: " fmt
>> +
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>>  #include <linux/pci.h>
>> @@ -153,7 +155,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
>>  static int dgap_gettok(char **in);
>>  static char *dgap_getword(char **in);
>>  static int dgap_checknode(struct cnode *p);
>> -static void dgap_err(char *s);
>>
>>  /*
>>   * Function prototypes from dgap_sysfs.h
>> @@ -815,7 +816,7 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
>>       if (ret)
>>               goto free_brd;
>>
>> -     pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
>> +     pr_info("board %d: %s (rev %d), irq %ld\n",
>>               boardnum, brd->name, brd->rev, brd->irq);
>
> Almost all of the pr_*() calls in this driver should be converted over
> to use dev_*() calls instead.  And some of them, like this one, should
> be removed entirely (no need for a driver to be "noisy" when a device
> for it is found, it should be quiet if at all possible, unless something
> went wrong.)
>
> So can you do that here instead?  I've applied the earlier patches in
> this series, and stopped here.
OK. I can. pr_*() calls are replaced with dev_*() calls.
And also removes some of print message which are useless like "out
of memory"

Thanks.

regards,
Daeseok Youn
>
> thanks,
>
> greg k-h
