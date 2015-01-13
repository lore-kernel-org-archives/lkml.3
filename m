Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbbAMAXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:23:46 -0500
Received: from smtp310.phy.lolipop.jp ([210.157.22.78]:53978 "EHLO
	smtp310.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbbAMAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:23:45 -0500
Message-ID: <54B4658A.8070602@sakamocchi.jp>
Date: Tue, 13 Jan 2015 09:23:38 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: alsa-devel@alsa-project.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: firewire: fireworks: fireworks_command: Remove
 unused function
References: <1420908780-31468-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <s5hlhl92thf.wl-tiwai@suse.de>
In-Reply-To: <s5hlhl92thf.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 12 2014 01:05, Takashi Iwai wrote:
> At Sat, 10 Jan 2015 17:53:00 +0100,
> Rickard Strandqvist wrote:
>>
>> Remove the function snd_efw_command_set_resp_addr() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> I leave the decision to Sakamoto-san and Clemens.  Let me know if this
> should be applied or not.
> 
> 
> thanks,
> 
> Takashi

When removing this function, struct snd_efw.resp_addr_changable and
FLAG_RESP_ADDR_CHANGABLE, codes in get_hardware_info() can be also removed.

Originally, I planned to set expected response address at probing this
driver because I have no convinience about the initial value. On the
other hand, checking the flags needs a successful transaction. This is
like a story about 'chicken or the egg'. So I cannot achieve this.

Now that I have no reports about disorder in this point (this driver
cannot handle any Fireworks devices), this function has just a meaning
of FYI.


Regards

Takashi Sakamoto

>> ---
>>  sound/firewire/fireworks/fireworks.h         |    2 --
>>  sound/firewire/fireworks/fireworks_command.c |   21 ---------------------
>>  2 files changed, 23 deletions(-)
>>
>> diff --git a/sound/firewire/fireworks/fireworks.h b/sound/firewire/fireworks/fireworks.h
>> index 4f0201a..693b76b 100644
>> --- a/sound/firewire/fireworks/fireworks.h
>> +++ b/sound/firewire/fireworks/fireworks.h
>> @@ -189,8 +189,6 @@ enum snd_efw_transport_mode {
>>  	SND_EFW_TRANSPORT_MODE_WINDOWS	= 0,
>>  	SND_EFW_TRANSPORT_MODE_IEC61883	= 1,
>>  };
>> -int snd_efw_command_set_resp_addr(struct snd_efw *efw,
>> -				  u16 addr_high, u32 addr_low);
>>  int snd_efw_command_set_tx_mode(struct snd_efw *efw,
>>  				enum snd_efw_transport_mode mode);
>>  int snd_efw_command_get_hwinfo(struct snd_efw *efw,
>> diff --git a/sound/firewire/fireworks/fireworks_command.c b/sound/firewire/fireworks/fireworks_command.c
>> index 166f805..e0cc467 100644
>> --- a/sound/firewire/fireworks/fireworks_command.c
>> +++ b/sound/firewire/fireworks/fireworks_command.c
>> @@ -175,27 +175,6 @@ end:
>>  }
>>  
>>  /*
>> - * The address in host system for transaction response is changable when the
>> - * device supports. struct hwinfo.flags includes its flag. The default is
>> - * MEMORY_SPACE_EFW_RESPONSE.
>> - */
>> -int snd_efw_command_set_resp_addr(struct snd_efw *efw,
>> -				  u16 addr_high, u32 addr_low)
>> -{
>> -	__be32 addr[2];
>> -
>> -	addr[0] = cpu_to_be32(addr_high);
>> -	addr[1] = cpu_to_be32(addr_low);
>> -
>> -	if (!efw->resp_addr_changable)
>> -		return -ENOSYS;
>> -
>> -	return efw_transaction(efw, EFC_CAT_HWCTL,
>> -			       EFC_CMD_HWINFO_SET_RESP_ADDR,
>> -			       addr, sizeof(addr), NULL, 0);
>> -}
>> -
>> -/*
>>   * This is for timestamp processing. In Windows mode, all 32bit fields of second
>>   * CIP header in AMDTP transmit packet is used for 'presentation timestamp'. In
>>   * 'no data' packet the value of this field is 0x90ffffff.
>> -- 
>> 1.7.10.4

