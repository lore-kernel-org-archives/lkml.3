Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3EaRGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:06:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59234 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751992Ab3EaRGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:06:38 -0400
Message-ID: <1370019998.10556.82.camel@joe-AO722>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 31 May 2013 10:06:38 -0700
In-Reply-To: <s5hwqqf1an3.wl%tiwai@suse.de>
References: <s5ha9nbinre.wl%tiwai@suse.de>
	 <Pine.LNX.4.44L0.1305311014330.1276-100000@iolanthe.rowland.org>
	 <s5hwqqf1an3.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 16:34 +0200, Takashi Iwai wrote:
> Also, another expected problem is that neither card->card_dev nor
> card->dev are set when snd_card_err() is called.  Many drivers set the
> device pointers at the late stage just before the device
> registration.  So, systematic replacements won't work as expected in
> many cases.  (The same is applied for replacement with dev_*(), too.)

If all the pointers are null, then the logging function could
use pr_<level> and %pf, __builtin_return_addr() or another
method to look up the module name.


