Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3BSOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:54:58 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56120 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab3BSOy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:54:57 -0500
Message-ID: <51239234.8080702@gmail.com>
Date: Tue, 19 Feb 2013 16:54:44 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130218 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] NET: ath5k, check ath5k_eeprom_mode_from_channel retval
References: <1360244680-10370-1-git-send-email-jslaby@suse.cz> <CAFtRNNwUaGFejpGHydDKD1Sn4zLYbmAeyO5zkS7wsHFZ_2yRfA@mail.gmail.com> <51237FC7.3070509@suse.cz>
In-Reply-To: <51237FC7.3070509@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Feb 19 15:36:07 2013, Jiri Slaby wrote:
> On 02/18/2013 01:47 AM, Nick Kossifidis wrote:
>> int
>> ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
>> {
>>         switch (channel->hw_value) {
>>         case AR5K_MODE_11A:
>>                 return AR5K_EEPROM_MODE_11A;
>>         case AR5K_MODE_11G:
>>                 return AR5K_EEPROM_MODE_11G;
>>         case AR5K_MODE_11B:
>>                 return AR5K_EEPROM_MODE_11B;
>>         default:
>>                 return -1;
>>         }
>> }
>>
>> I think we should just change that default to return 0 instead and add
>> an ATH5K_WARN there.
>
> Something like the attached patch? It needs ah to be propagated to
> eeprom. If you are fine with that, I'll send it as patch...
>
> thanks,

Just move the prototype on ath5k.h with the rest of them...

1523 /* EEPROM access functions */
1524 int ath5k_eeprom_init(struct ath5k_hw *ah);
1525 void ath5k_eeprom_detach(struct ath5k_hw *ah);
