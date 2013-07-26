Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab3GZTEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:04:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54706 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3GZTET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130726184644.GV9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
	<1374863133-6745-2-git-send-email-eu@felipetonello.com>
	<20130726184644.GV9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 12:04:17 -0700
Message-ID: <CAGrhNMznQrbCxMs=0pVRDL9ott8kBX15yT9EyyS8zpzq03Fwuw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
From: Felipe Tonello <eu@felipetonello.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jul 26, 2013 at 11:46 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 11:25:30AM -0700, Felipe F. Tonello wrote:
>
>> -     snprintf(kctl->id.name, sizeof(kctl->id.name), "%s Jack", name);
>> +
>> +     strlcpy(kctl->id.name, name, sizeof(kctl->id.name));
>
> This looks like it'd break existing users unless they are updated to
> remove the "Jack" from their calls?

Yes, that's why I appended the " Jack" in snd_jack_new().

>
>>   * @type:  a bitmask of enum snd_jack_type values that can be detected by
>>   *         this jack
>> + * @idx:   index of this control item
>>   * @jjack: Used to provide the allocated jack object to the caller.
>
> "The index of the ALSA control created to represent the jack.

Ok.

Felipe Tonello
