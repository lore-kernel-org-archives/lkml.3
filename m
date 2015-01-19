Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbbASJx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:53:59 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44152 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbASJx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:53:58 -0500
Message-ID: <54BCD433.3070407@suse.cz>
Date: Mon, 19 Jan 2015 10:53:55 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/3] sound: dummy, avoid races with timer
References: <1421660576-8435-1-git-send-email-jslaby@suse.cz>	<1421660576-8435-3-git-send-email-jslaby@suse.cz> <s5hwq4jqewi.wl-tiwai@suse.de>
In-Reply-To: <s5hwq4jqewi.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015, 10:49 AM, Takashi Iwai wrote:
>> @@ -322,12 +325,14 @@ static snd_pcm_uframes_t
>>  dummy_systimer_pointer(struct snd_pcm_substream *substream)
>>  {
>>  	struct dummy_systimer_pcm *dpcm = substream->runtime->private_data;
>> +	unsigned long flags;
>>  	snd_pcm_uframes_t pos;
>>  
>> -	spin_lock(&dpcm->lock);
>> +	spin_lock_irqsave(&dpcm->lock, flags);
>>  	dummy_systimer_update(dpcm);
>>  	pos = dpcm->frac_pos / HZ;
>> -	spin_unlock(&dpcm->lock);
>> +	spin_unlock_irqrestore(&dpcm->lock, flags);
>> +
> 
> This chunk is superfluous.  The pointer callback is guaranteed to be
> called in the irq-disabled context.

Oh, my bad, I was looking at snd_compr_ops->pointer which is not the case.

-- 
js
suse labs
