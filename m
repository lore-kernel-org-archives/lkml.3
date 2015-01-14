Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbbANM5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:57:09 -0500
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1062 "EHLO
	smtp-out-243.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbANM5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:57:08 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27894
Message-ID: <54B6679F.1030706@metafoo.de>
Date: Wed, 14 Jan 2015 13:57:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is active
 case kernel crash
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com> <s5h1tmyiof7.wl-tiwai@suse.de> <20150113215412.GS4160@sirena.org.uk> <s5hr3ux24em.wl-tiwai@suse.de> <54B625A8.8090406@metafoo.de> <s5hoaq121gh.wl-tiwai@suse.de> <54B63E4F.2010506@metafoo.de> <s5hwq4phbzr.wl-tiwai@suse.de> <20150114120228.GT4160@sirena.org.uk>
In-Reply-To: <20150114120228.GT4160@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 01:02 PM, Mark Brown wrote:
[...]
>>> I don't think that we need to prevent module unload when a stream is active.
>>>   From a framework point of view is not different from hot-unplug. I don't
>>> see a reason why we'd jump through hoops to actively forbid removing the
>>> module once it works just fine.
>
>> Well, the module unload means a more drastic cleanup.  Even if you
>> unbind, the code and data are still there while module unload may
>> clean them up all.
>
>> Above all, disallowing the module unload while using is the common
>> behavior of any other drivers.  Why do we have to be a rebel against
>> all civil manner? :)
>
> That's not true for everything and for ASoC I'd tend to assume that the
> user knows what they're doing and has a good reason for it; it's
> certainly something that can be helpful in development.


My personal opinion on this is that disallowing module removal while a 
driver registered by the module when is in use, while there is no technical 
reason to do so, is a anti-feature. Whether in ALSA or elsewhere.

But looking at the source it seems that this is a core feature of ALSA and 
at least for the card module itself it will do the ref-counting when a 
stream is started/stopped. And we even support setting the owner of a card 
in ASoC. It's just that pretty much no ASoC card driver bothers to set the 
owner field in the snd_soc_card struct. So this particular problem can be 
fixed by updating the imx-wm8962 driver to set the owner field.

- Lars

