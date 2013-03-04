Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3CDHzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:55:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3CDHzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:55:46 -0500
Message-ID: <51345380.5030504@canonical.com>
Date: Mon, 04 Mar 2013 08:55:44 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 093/153] ALSA: hda - hdmi: Make jacks phantom, if theyre not
 detectable
References: <20130304033716.795093499@decadent.org.uk> <1362374037.3768.298.camel@deadeye.wl.decadent.org.uk> <51345148.1040102@canonical.com> <20130304074850.GA1136@kroah.com>
In-Reply-To: <20130304074850.GA1136@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 08:48 AM, Greg Kroah-Hartman wrote:
> On Mon, Mar 04, 2013 at 08:46:16AM +0100, David Henningsson wrote:
>> On 03/04/2013 06:13 AM, Ben Hutchings wrote:
>>> On Mon, 2013-03-04 at 03:38 +0000, Ben Hutchings wrote:
>>>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: David Henningsson <david.henningsson@canonical.com>
>>>>
>>>> commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream.
>>>>
>>>> Just as for analog codecs, a jack that isn't suitable for detection
>>>> (in this case, NO_PRESENCE was set) should be a phantom Jack
>>>> instead of a normal one.
>>>>
>>>> Thanks to Raymond Yau for spotting.
>>>>
>>>> BugLink: https://bugs.launchpad.net/bugs/961286
>>>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=903869
>>>> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
>>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>> [bwh: Backported to 3.2: adjust context]
>>>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>>>
>>> David, do I need to change this further for 3.2.y?
>>
>> Greg and Ben,
>>
>> Given some thought, the definition of is_jack_detectable has
>> changed/improved over kernels. Therefore I think it's safer not to
>> apply the patch at all for kernels earlier than 3.6. Let's revisit
>> this decision if there's actually a user demand for this fix.
>
> So should I revert this in the next 3.4 release, as it's now in the
> 3.4.35 release.

That seems to be the safest option; given that we don't get people with 
the actual hardware to test the different options and report back which 
one works best.

Sorry for the late reply.

-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
