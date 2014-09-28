Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaI1IFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:05:36 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:46065 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaI1IFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:05:32 -0400
MIME-Version: 1.0
X-Originating-IP: [128.68.177.111]
In-Reply-To: <20140928070923.GA2087@redhat.com>
References: <1411852301-26857-1-git-send-email-yocto6@gmail.com>
	<20140928070923.GA2087@redhat.com>
Date: Sun, 28 Sep 2014 12:05:30 +0400
Message-ID: <CAOJe8K1nkeVjNpNoUBxuJv-YXj3Wr_oH86yR31U7w3Jq5j7oxw@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH] wireless: Remove unnessary write over of
 register 11 in rt2800lib.c
From: Denis Kirjanov <kda@linux-powerpc.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Nicholas Krause <yocto6@gmail.com>, IvDoorn@gmail.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or someone with the hardware has to test and check that...

On 9/28/14, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sat, Sep 27, 2014 at 05:11:41PM -0400, Nicholas Krause wrote:
>> This removes the unnecessary  overwrite of register 11 in the function,
>> rt2800_config_channel as we are already writing a correct value to the
>> register with rt2800_rfcsr_write(rt2x00dev,11.rfcsr).
> What make you sure that overwrite is unnecessary ?
>
>>
>> Signed-off-by: Nicholas Krause <yocto6@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
>> b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 893c9d5..fb0ae38 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -2787,8 +2787,6 @@ static void rt2800_config_channel_rf55xx(struct
>> rt2x00_dev *rt2x00dev,
>>
>>  	if (rf->channel <= 14) {
>>  		rt2800_rfcsr_write(rt2x00dev, 10, 0x90);
>> -		/* FIXME: RF11 owerwrite ? */
>> -		rt2800_rfcsr_write(rt2x00dev, 11, 0x4A);
> We need a prove that remove is correct, i.e. some reference to
> vendor code or spec that current writing register twice with
> different values is wrong.
>
> NACK for the patch.
>
> Stanislaw
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
