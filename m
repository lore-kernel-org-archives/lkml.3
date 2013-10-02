Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3JBQvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:51:31 -0400
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:53099 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763Ab3JBQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:51:30 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 12:51:29 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <524C4D0D.1070903@iki.fi>
Date: Wed, 02 Oct 2013 19:42:53 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130914 Thunderbird/17.0.9
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org,
        =?UTF-8?B?UGV0ZXIgRnLDvGhiZXJnZXI=?= <fritsch@xbmc.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT v2 0/4] ALSA: hda - hdmi: ATI/AMD multi-channel and
 HBR support
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi> <s5hli2bu4gs.wl%tiwai@suse.de>
In-Reply-To: <s5hli2bu4gs.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.10.2013 17:34, Takashi Iwai kirjoitti:
> At Tue,  1 Oct 2013 23:30:52 +0300,
> Anssi Hannula wrote:
[...]
>> Anssi Hannula (4):
>>       ALSA: hda - hdmi: Add ATI/AMD multi-channel audio support
>>       ALSA: hda - hdmi: Add ELD emulation for ATI/AMD codecs
>>       ALSA: hda - hdmi: Add HBR bitstreaming support for ATI/AMD HDMI codecs
>>       ALSA: hda - hdmi: Disable ramp-up/down for non-PCM on AMD codecs
> 
> 
> The patches generally look good, but I'm thinking whether it's cleaner
> to create a new ops items.  Maybe it can be specific to HDMI codec,
> e.g.
> 
> struct hda_hdmi_ops {
> 	int (*get_chan_slot)(struct hda_codec *codec, hda_nid_t pin, int slot);
> 	int (*set_chan_slot)(struct hda_codec *codec, hda_nid_t pin, int setup);
> 	int (*set_ca)(struct hda_codec *codec, hda_nid_t pin, int ca);
> 	....
> }
> 
> It's not sexy to have a thing like is_atihdmi() in the common header
> and see it in everywhere.

OK, will do that for next version.

Regarding hda_eld.c, I guess I'll add struct hda_hdmi_ops to struct
hdmi_spec, then keep snd_hdmi_ati_get_eld() in hda_eld.c but make it
non-static, so I can assign the correct _get_eld in patch_hdmi.c?


P.S. I asked whether new callbacks should be added in the previous RFC
message, but I guess that was easy to overlook as the message was a bit
incoherent... :)

--
Anssi Hannula

> thanks,
> 
> Takashi
> 
>>
>>  sound/pci/hda/hda_eld.c    | 157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  sound/pci/hda/hda_local.h  |   5 +++
>>  sound/pci/hda/patch_hdmi.c | 424 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
>>  3 files changed, 547 insertions(+), 39 deletions(-)
>>
>> -- 
>> Anssi Hannula
>>


-- 
Anssi Hannula
