Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab3E3TMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:12:06 -0400
Received: from mail1.perex.cz ([77.48.224.245]:53141 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379Ab3E3TLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:11:45 -0400
X-Greylist: delayed 1349 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 15:11:44 EDT
Message-ID: <51A79F25.6040007@perex.cz>
Date: Thu, 30 May 2013 20:49:09 +0200
From: Jaroslav Kysela <perex@perex.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Joe Perches <joe@perches.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
References: <Pine.LNX.4.44L0.1305301411370.1137-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1305301411370.1137-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date 30.5.2013 20:14, Alan Stern wrote:
> On Wed, 29 May 2013, Joe Perches wrote:
> 
>> On Wed, 2013-05-29 at 15:27 -0400, Alan Stern wrote:
>>> Has there been any thought of improving snd_printk(), or even better,
>>> changing the call sites to use the dev_*() routines instead?
>>
>> Perhaps better would be to add and use some combination of
>> type specific logging message functions/macros like:
>>
>> void snd_<level>(const struct snd_device *dev, const char *fmt, ...)
>> void snd_card_<level>(const struct snd_card *card, const char *fmt, ...)
>> void snd_ac97_<level>(const struct snd_ac97 *ac97, const char *fmt, ...)
>>
>> allowing NULL as the type pointer when necessary/appropriate.
> 
> Almost anything would be better than the current situation.  The only 
> enhancement provided by CONFIG_SND_VERBOSE_PRINTK is to print the 
> filename and line number, which is relatively unhelpful (unless there 
> are multiple copies of the same message in several places).

I don't think that it's useless to see the origin of the source message
from the first glance. It may be improved, of course, but adding more
and more functions with minor benefits is another step to another hell.

					Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project; Red Hat, Inc.
