Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaFRFvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:51:00 -0400
Received: from mx02.posteo.de ([89.146.194.165]:58523 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbaFRFu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:50:59 -0400
Message-ID: <53A128A8.5080206@posteo.de>
Date: Wed, 18 Jun 2014 07:50:32 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drbd: change one-bit bitfield to be an unsigned int
References: <alpine.DEB.2.02.1406160225510.30205@chino.kir.corp.google.com> <1402988047-16364-1-git-send-email-martink@posteo.de> <alpine.DEB.2.02.1406171243260.18156@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406171243260.18156@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-06-17 21:46, schrieb David Rientjes:
> On Tue, 17 Jun 2014, Martin Kepplinger wrote:
> 
>> The one-bit bitfields are assigned true (1) or false (0) and checked
>> for them respectively. While it should work either way and -1 is true
>> as well it is more clear to see what's going on when using an unsigned int
>> because 1 doesn't silently become -1 behind the label true.
>>
> 
> Nothing is silently becoming anything, I have no idea what you're trying 
> to address.  Is there something in drivers/block/drbd that needs this 
> change?

nope.

> 
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>> ---
>> Thanks for looking at it. This is more of a question: Does this make sense
>> to you now? I can be mistaken. It just wasn't totally clear to me at first
>> sight and even though it should be, why not try to improve it.
>>
> 
> There's no improvement here, you realize that the sign of one-bit 
> bitfields are implementation defined, correct?  On what implementation 
> does this patch make a difference?
> 
> If you are trying to convert these to unsigned for consistency, then just 
> say so in the changelog and don't talk about silent changes or comparisons 
> to true and false that obfuscate the fact that this is just a trivial 
> cleanup that is based on the author's own preference rather than anything 
> else.

learning learning learning. in this case, why sparse calls this dubious.
This would be more appropriate on kernelnewbies or the like, sorry.

> 
>> sparse called it 'dubious' before the change.
>>
>> (built but untested)
>>
>>  drivers/block/drbd/drbd_interval.h |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
>> index f38fcb0..8d670e6 100644
>> --- a/drivers/block/drbd/drbd_interval.h
>> +++ b/drivers/block/drbd/drbd_interval.h
>> @@ -9,8 +9,8 @@ struct drbd_interval {
>>  	sector_t sector;	/* start sector of the interval */
>>  	unsigned int size;	/* size in bytes */
>>  	sector_t end;		/* highest interval end in subtree */
>> -	int local:1		/* local or remote request? */;
>> -	int waiting:1;
>> +	unsigned int local:1;	/* local or remote request? */
>> +	unsigned int waiting:1;
>>  };
>>  
>>  static inline void drbd_clear_interval(struct drbd_interval *i)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

