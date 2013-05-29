Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab3E2TwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:52:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49345 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758477Ab3E2Tvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:51:53 -0400
Message-ID: <1369857112.22004.119.camel@joe-AO722>
Subject: Re: Improving or replacing snd_printk()
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 12:51:52 -0700
In-Reply-To: <Pine.LNX.4.44L0.1305291516090.885-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1305291516090.885-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 15:27 -0400, Alan Stern wrote:
> Has there been any thought of improving snd_printk(), or even better,
> changing the call sites to use the dev_*() routines instead?

Perhaps better would be to add and use some combination of
type specific logging message functions/macros like:

void snd_<level>(const struct snd_device *dev, const char *fmt, ...)
void snd_card_<level>(const struct snd_card *card, const char *fmt, ...)
void snd_ac97_<level>(const struct snd_ac97 *ac97, const char *fmt, ...)

allowing NULL as the type pointer when necessary/appropriate.

