Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbbALSNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:13:46 -0500
Received: from smtp-1.concepts.nl ([213.197.30.124]:38108 "EHLO
	smtp-1.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbbALSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:13:43 -0500
Message-ID: <54B40ED0.5090004@xmsnet.nl>
Date: Mon, 12 Jan 2015 19:13:36 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>
Subject: Re: 3.19-rc1 regression bisected No sound on Dell Latitude d430
References: <54B26ACE.90406@xmsnet.nl>	<s5hy4p92ue0.wl-tiwai@suse.de>	<54B2EEC5.7050805@xmsnet.nl> <s5h1tn032ym.wl-tiwai@suse.de>
In-Reply-To: <s5h1tn032ym.wl-tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Concepts-MailScanner-Information: Please contact abuse@concepts.nl for more information
X-Concepts-MailScanner-ID: 1YAjUf-0005Zd-JV
X-Concepts-MailScanner: Found to be clean
X-Concepts-MailScanner-SpamCheck: 
X-Concepts-MailScanner-From: jmdebruin@xmsnet.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 07:52 AM, Takashi Iwai wrote:
> At Sun, 11 Jan 2015 22:44:37 +0100,
> Hans de Bruin wrote:
>>
>> On 01/11/2015 04:45 PM, Takashi Iwai wrote:
>>> At Sun, 11 Jan 2015 13:21:34 +0100,
>>> Hans de Bruin wrote:
>>>>
>>>> This commit:
>>>>
>>>> commit 3abb4f4d0e7aaad0d12004b5057f4486a688752b
>>>> Author: David Henningsson <david.henningsson@canonical.com>
>>>> Date:   Thu Oct 16 15:33:46 2014 +0200
>>>>
>>>>        ALSA: hda - Use "Line Out" name instead of "PCM" when there are
>>>> other outputs
>>>>
>>>>        In case there are speakers or headphones as well, anything that only
>>>>        covers the line out should not be labelled "PCM". Let's name it
>>>>        "Line Out" instead for clarity.
>>>>
>>>>        Signed-off-by: David Henningsson <david.henningsson@canonical.com>
>>>>        Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>>
>>>> breaks the sound on my dell laptop.
>>>
>>> What sound?  From the speaker, the headphone or the dock output?
>>
>> The speaker. I have not checked the other exits
>>
>>> Are you using PulseAudio?
>>
>> No
>>
>>> What if you adjust/unmute the volume
>>> (likely "Line Out") manually?
>>
>> running 3.18 alsamixer show these options:
>>
>> Master
>> PCM
>> Mic Boost
>> Auto Mute mode
>>
>> PCM affects the volume of the speaker.
>>
>> running 3.19-rc1 alsamixer show these options:
>>
>> Master
>> PCM
>> Line Out
>> Mic Boost
>> Auto Mute mode
>>
>> Line out now controls the vole of the speaker (this 'new' channel had
>> volume 0 so did not hear anything). Changing PCM has no effect.
>
> OK, then this is the expected change.  It was a bug that we assigned
> "PCM" only for the speaker and now it's corrected.  Now "PCM" is still
> present but this was created by alsa-lib softvol pcm, and has nothing
> to do directly with the driver itself.  This control is used only when
> you play the stream with the dedicated setup, i.e. via "default" or
> "sysdefault" device name, not via "hw", "plughw", etc.
>

Thanks for the explanation and the quick response. The issue can be closed.

-- 
Hans



