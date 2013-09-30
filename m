Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3I3IYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:24:24 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35071 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3I3IYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1309271219530.10254-100000@netrider.rowland.org>
References: <1380207292-16968-11-git-send-email-ulf.hansson@linaro.org>
	<Pine.LNX.4.44L0.1309271219530.10254-100000@netrider.rowland.org>
Date: Mon, 30 Sep 2013 10:24:20 +0200
Message-ID: <CAPDyKFoN_m7P-hpDvnew4qEWOPxBUaffpP2ZYjVEfE1XVsRjTw@mail.gmail.com>
Subject: Re: [PATCH 10/27] mmc: vub300: Remove redundant suspend and resume callbacks
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2013 18:22, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 26 Sep 2013, Ulf Hansson wrote:
>
>> Suspend and resume of cards are handled by the protocol layer and
>> consequently the mmc_suspend|resume_host APIs are marked as deprecated.
>>
>> While moving away from using the deprecated APIs, there are nothing
>> left to be done for the suspend and resume callbacks, so remove them.
>>
>> Cc: Tony Olech <tony.olech@elandigitalsystems.com>
>> Cc: linux-usb@vger.kernel.org
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> ---
>>  drivers/mmc/host/vub300.c |   30 ------------------------------
>>  1 file changed, 30 deletions(-)
>>
>> diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
>> index e9028ad..db99edc 100644
>> --- a/drivers/mmc/host/vub300.c
>> +++ b/drivers/mmc/host/vub300.c
>> @@ -2389,34 +2389,6 @@ static void vub300_disconnect(struct usb_interface *interface)
>>       }
>>  }
>>
>> -#ifdef CONFIG_PM
>> -static int vub300_suspend(struct usb_interface *intf, pm_message_t message)
>> -{
>> -     struct vub300_mmc_host *vub300 = usb_get_intfdata(intf);
>> -     if (!vub300 || !vub300->mmc) {
>> -             return 0;
>> -     } else {
>> -             struct mmc_host *mmc = vub300->mmc;
>> -             mmc_suspend_host(mmc);
>> -             return 0;
>> -     }
>> -}
>> -
>> -static int vub300_resume(struct usb_interface *intf)
>> -{
>> -     struct vub300_mmc_host *vub300 = usb_get_intfdata(intf);
>> -     if (!vub300 || !vub300->mmc) {
>> -             return 0;
>> -     } else {
>> -             struct mmc_host *mmc = vub300->mmc;
>> -             mmc_resume_host(mmc);
>> -             return 0;
>> -     }
>> -}
>> -#else
>> -#define vub300_suspend NULL
>> -#define vub300_resume NULL
>> -#endif
>>  static int vub300_pre_reset(struct usb_interface *intf)
>>  {                            /* NOT irq */
>>       struct vub300_mmc_host *vub300 = usb_get_intfdata(intf);
>> @@ -2437,8 +2409,6 @@ static struct usb_driver vub300_driver = {
>>       .name = "vub300",
>>       .probe = vub300_probe,
>>       .disconnect = vub300_disconnect,
>> -     .suspend = vub300_suspend,
>> -     .resume = vub300_resume,
>>       .pre_reset = vub300_pre_reset,
>>       .post_reset = vub300_post_reset,
>>       .id_table = vub300_table,
>
> You shouldn't do it this way.  The USB core treats drivers differently
> depending on whether their suspend and resume callbacks are defined.
> If those method pointers are NULL, the driver will be treated as though
> it doesn't support power management at all.
>
> You should keep the pointers and the routines.  The contents of the
> routines can be removed, leaving nothing but a "return 0;" line.

Thanks for your comment Alan. Did not know USB core was handling the
callbacks like that, should of course have checked that.

Instead of sending a v2, I have dropped this patch and just sent a new
one with an updated commit message as well.

Kind regards
Ulf Hansson

>
> Alan Stern
>
