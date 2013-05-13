Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3EMOa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:30:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43679 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab3EMOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:30:24 -0400
X-Sasl-enc: 4SCabrwJXh8JPFLs+MYP3smLbV0HLfRxr9efdXsdsycA 1368455420
Message-ID: <5190F8FA.9050201@ladisch.de>
Date: Mon, 13 May 2013 16:30:18 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Imre Deak <imre.deak@intel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 11/11] sound/oxygen_io: take msecs_to_jiffies_min into
 use
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com> <1368188011-23661-11-git-send-email-imre.deak@intel.com> <s5hr4hbq8sd.wl%tiwai@suse.de>
In-Reply-To: <s5hr4hbq8sd.wl%tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Imre Deak wrote:
>> Use msecs_to_jiffies_min instead of open-coding the same.
>>
>> +++ b/sound/pci/oxygen/oxygen_io.c
>> @@ -108,7 +108,7 @@ static int oxygen_ac97_wait(struct oxygen *chip, unsigned int mask)
>>  	wait_event_timeout(chip->ac97_waitqueue,
>>  			   ({ status |= oxygen_read8(chip, OXYGEN_AC97_INTERRUPT_STATUS);
>>  			      status & mask; }),
>> -			   msecs_to_jiffies(1) + 1);
>> +			   msecs_to_jiffies_min(1));
>
> This would change the behavior, I guess.

No, that's exactly how msecs_to_jiffies_min would be implemented.

> (Though, I'm not sure whether the original code was intentional.)

When I wrote this, I was not able to prove that msecs_to_jiffies always
rounds up.  (And I guess it doesn't; otherwise the _min variant would
not be needed.)


Regards,
Clemens
