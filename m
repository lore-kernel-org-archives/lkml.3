Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3CDHqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:46:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3CDHqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:46:19 -0500
Message-ID: <51345148.1040102@canonical.com>
Date: Mon, 04 Mar 2013 08:46:16 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: stable@vger.kernel.org, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 093/153] ALSA: hda - hdmi: Make jacks phantom, if theyre not
 detectable
References: <20130304033716.795093499@decadent.org.uk> <1362374037.3768.298.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1362374037.3768.298.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 06:13 AM, Ben Hutchings wrote:
> On Mon, 2013-03-04 at 03:38 +0000, Ben Hutchings wrote:
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: David Henningsson <david.henningsson@canonical.com>
>>
>> commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream.
>>
>> Just as for analog codecs, a jack that isn't suitable for detection
>> (in this case, NO_PRESENCE was set) should be a phantom Jack
>> instead of a normal one.
>>
>> Thanks to Raymond Yau for spotting.
>>
>> BugLink: https://bugs.launchpad.net/bugs/961286
>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=903869
>> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> [bwh: Backported to 3.2: adjust context]
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>
> David, do I need to change this further for 3.2.y?

Greg and Ben,

Given some thought, the definition of is_jack_detectable has 
changed/improved over kernels. Therefore I think it's safer not to apply 
the patch at all for kernels earlier than 3.6. Let's revisit this 
decision if there's actually a user demand for this fix.


>
> Ben.
>
>> ---
>>   sound/pci/hda/patch_hdmi.c |    3 +++
>>   1 file changed, 3 insertions(+)
>>
>> --- a/sound/pci/hda/patch_hdmi.c
>> +++ b/sound/pci/hda/patch_hdmi.c
>> @@ -1228,6 +1228,9 @@ static int generic_hdmi_build_jack(struc
>>   	int pcmdev = spec->pcm_rec[pin_idx].device;
>>
>>   	snprintf(hdmi_str, sizeof(hdmi_str), "HDMI/DP,pcm=%d", pcmdev);
>> +	if (!is_jack_detectable(codec, per_pin->pin_nid))
>> +		strncat(hdmi_str, " Phantom",
>> +			sizeof(hdmi_str) - strlen(hdmi_str) - 1);
>>
>>   	err = snd_hda_input_jack_add(codec, per_pin->pin_nid,
>>   			     SND_JACK_VIDEOOUT, pcmdev > 0 ? hdmi_str : NULL);
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe stable" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
