Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3JFMHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 08:07:49 -0400
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:36150 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab3JFMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 08:07:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <5251528B.4010506@iki.fi>
Date: Sun, 06 Oct 2013 15:07:39 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130914 Thunderbird/17.0.9
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UGV0ZXIgRnLDvGhiZXJnZXI=?= <fritsch@xbmc.org>
Subject: Re: [alsa-devel] [RFC/RFT v2 0/4] ALSA: hda - hdmi: ATI/AMD multi-channel
 and HBR support
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>  <1380870371.875.14.camel@Wailaba2> <524F51C6.7050203@iki.fi> <1381031338.10109.2.camel@Wailaba2>
In-Reply-To: <1381031338.10109.2.camel@Wailaba2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

06.10.2013 06:48, Olivier Langlois kirjoitti:
> 
>>>>
>>>>   o Contents of /proc/asound/cardX/eld#0. I'd like to see the contents
>>>>     both with radeon and with the proprietary fglrx driver in use
>>>>
>>> With fglrx 13.10 Beta 2:
>>>
>>> lano1106@whippet2 /proc/asound/card0 $ cat codec#0 
>>
>> Note I said eld#0, not codec#0 :)
>>
>> Though I guess the correct filename is actually eld#0.0.
>>
>> [...]
>>
> My mistake.
> 
> Here is the good content:
[...]

Does not look right. And after looking at the code I saw quite a big bug
which caused all of the rev3+ features to not work :)

Please change 0x1002791a to 0x1002aa01 in this part in the end of
sound/pci/hda/hda_local.h:

#define is_amdhdmi_rev3(codec) \
	((codec)->vendor_id == 0x1002791a && ((codec)->revisi

Then please test everything again. I.e.
  o speaker-test -D hdmi:CARD=Generic,DEV=0 -c8 -r192000 -F S32_LE

  o Is there any difference seen
    with these, in the beginning/end (i.e. fade-out/in):
    speaker-test -D hdmi:CARD=Generic,DEV=0,AES0=0x04 -c2 -r48000
    speaker-test -D hdmi:CARD=Generic,DEV=0,AES0=0x06 -c2 -r48000

  o Also, is there a difference in the beginning of these
    (maybe garbage sound and/or slightly slower startup?):
    aplay -Dhdmi:CARD=Generic,DEV=0,AES0=4 -r44100 -f s16_le -c2
testi.dts.cut.spdif
    aplay -Dhdmi:CARD=Generic,DEV=0,AES0=6 -r44100 -f s16_le -c2
testi.dts.cut.spdif

  o Contents of /proc/asound/cardX/eld#0.0

Thanks a lot :)

-- 
Anssi Hannula
