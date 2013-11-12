Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3KLWjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:39:01 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42851 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3KLWiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:38:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131112210641.GB23241@kroah.com>
References: <1384281793-4733-1-git-send-email-alexandre.f.demers@gmail.com>
	<52827E16.1030001@lwfinger.net>
	<20131112210641.GB23241@kroah.com>
Date: Tue, 12 Nov 2013 17:38:49 -0500
Message-ID: <CAPEhTTFRW02A+4cgOB_gQ=Q_VJ9z-NjF_Jyw1rogiqebg5hA=Q@mail.gmail.com>
Subject: Re: [PATCH] Silence r8712u info and add verbose option v2
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry and Greg,
You are right about the v2 thing and the Signed-off-by. It's the first
time I submit a patch directly to the kernel list, I didn't go to the
bottom of the SubmittingPatches, I should have read the whole document
and not stop in the middle of it. I'll finish reading it and do what
is expected. Greg, I understand your comment: I would have had the
answer if I had read the whole document (it's in there, I've just seen
it).

However, I'll take the opportunity you are offering me, Larry, with
your last question: I was asking myself the same question about simply
deleting the statement which seems pretty useless to me. On the other
hand, should we continue writing patches against r8712u? I'm not aware
of the conclusion about replacing r8712u by r92su. Was there any
decision taken on the subject?

Thank you,
Alexandre D


On Tue, Nov 12, 2013 at 4:06 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 12, 2013 at 01:14:30PM -0600, Larry Finger wrote:
>> On 11/12/2013 12:43 PM, Alexandre Demers wrote:
>> > r8712u pollutes dmesg and logs. Silence it and add a verbose option to KConfig if we ever
>> > really want to hear about it.
>> >
>> > v2: keep netdev_info instead of replacing it by a KERN_NOTICE
>> >
>> > ---
>> >   drivers/staging/rtl8712/Kconfig        | 7 +++++++
>> >   drivers/staging/rtl8712/rtl871x_mlme.c | 7 ++++---
>> >   2 files changed, 11 insertions(+), 3 deletions(-)
>>
>> Do you really want the "v2" to be part of the patch title in the git repos? I
>> expect not, thus you should put it inside the []. All that stuff is stripped off
>> when the patch is merged.
>>
>> Similarly, do you want the v2 line in the patch description to be part of the
>> permanent record? If not, move it below the --- line.
>>
>> You are also missing a Signed-off-by: line. Have you read
>> Documentation/SubmittingPatches? At least you should run every patch through
>> scripts/checkpatch.pl before submitting it.
>>
>> Finally, why do you want to add another Kconfig variable? I suggest either
>> deleting the logging statement, or commenting it out. I'm not sure that this
>> info would ever need logging.
>
> To be a bit more clear here, we are activly _removing_ driver and
> subsystem specific DEBUG configuration flags, and moving everything to
> using the dynamic debug infrastructure in the kernel, as no user ever
> rebuilds their kernels/drivers, and we want to be able to get debugging
> information from them at times.
>
> thanks,
>
> greg k-h
