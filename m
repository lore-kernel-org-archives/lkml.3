Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaKHSVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:21:39 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:39906 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbaKHSVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:21:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141031114107.GE10778@ulmo.nvidia.com>
References: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
	<1414699267-17970-2-git-send-email-abrestic@chromium.org>
	<20141031114107.GE10778@ulmo.nvidia.com>
Date: Sat, 8 Nov 2014 23:51:35 +0530
Message-ID: <CAJe_ZhcC-nEUQSxVy3AUkAvWrM74TeafX1umqVuWxBSQ=zVdqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mailbox: Don't unnecessarily re-arm the polling timer
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2014 17:11, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Thu, Oct 30, 2014 at 01:01:07PM -0700, Andrew Bresticker wrote:
>> poll_txdone() will unconditionally re-arm the polling timer if there was
>> an active request, even if the active request completed and no other
>> requests were submitted.  This is fixed by:
>>  - only re-arming the timer if the controller reported that the current
>>    transmission has not completed, and,
>>  - moving the call to poll_txdone() into msg_submit() so that the
>>    controller gets polled (and the timer re-armed, if necessary) whenever
>>    a new message is submitted.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  drivers/mailbox/mailbox.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
>> index 5008028..26f74ad 100644
>> --- a/drivers/mailbox/mailbox.c
>> +++ b/drivers/mailbox/mailbox.c
>> @@ -28,6 +28,8 @@
>>  static LIST_HEAD(mbox_cons);
>>  static DEFINE_MUTEX(con_mutex);
>>
>> +static void poll_txdone(unsigned long data);
>
> I think I'd rather move poll_txdone() here to avoid the forward
> declaration, but either way:
>
> Reviewed-by: Thierry Reding <treding@nvidia.com>
>
Does the 'extra' timer fire cause some issue? I believe it shouldn't.
Anyways, I have applied the patch.

Thanks
Jassi
