Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaFBWJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:09:53 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43100 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaFBWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:09:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140602084122.GT15585@mwanda>
References: <1401622243-13364-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140602084122.GT15585@mwanda>
Date: Tue, 3 Jun 2014 00:09:51 +0200
Message-ID: <CAFo99gaspcZu_1u0u6COR62SF2_ZAjFTt0eWc75FM2_+SmudvA@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c: Cleaning up
 memory leak
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Okay, this code has been changed in linux-next, before the allocation
before the switch statement.

Yes, I repeat it to myself..  I'll check everything against linux-next
in the future!


Best regards
Rickard Strandqvist


2014-06-02 10:41 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Jun 01, 2014 at 01:30:43PM +0200, Rickard Strandqvist wrote:
>> There is a risk for memory leak in when something unexpected happens
>> and the function returns.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> index 23d539d..27e0243 100644
>> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> @@ -1822,6 +1822,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
>>               alg_name = "CCMP";
>>               break;
>>       default:
>> +             kfree(param);
>
> Wat?  Param isn't even allocated at this point.  It gets allocated a
> couple lines later.
>
> regards,
> dan carpenter
>
