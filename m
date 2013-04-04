Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab3DDJib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:38:31 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50043 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758957Ab3DDJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:38:29 -0400
Message-ID: <515D4A0D.7070302@suse.cz>
Date: Thu, 04 Apr 2013 11:38:21 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <5109A8F1.9040707@suse.cz> <5109B11C.2010400@suse.cz> <5170962.qHnbnlVDfx@vostro.rjw.lan> <20130131070926.GC4926@pd.tnic> <510A2B1C.1060108@suse.cz> <20130131131805.GG4926@pd.tnic> <20130131132400.GH4926@pd.tnic> <5130A55E.8030508@suse.cz> <515D2C79.7040904@suse.cz> <20130404093302.GB32271@pd.tnic>
In-Reply-To: <20130404093302.GB32271@pd.tnic>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:33 AM, Borislav Petkov wrote:
> On Thu, Apr 04, 2013 at 09:32:09AM +0200, Jiri Slaby wrote:
>> And yesterday I plugged in an ethernet cable for a wihle and guess
>> what happened today: Uhhuh. NMI received for unknown reason 2c on CPU
>> 0.
>>
>> Still holds that this is the first time since Jan.
> 
> Yeah, you could try my sure-fire way to trigger it:
> 
> * boot the box without any "nmi_watchdog" tweaks on the kernel cmdline -
> i.e. it should be enabled.
> 
> * turn off NMI watchdog through powertop or directly through
> /proc/sys/kernel/nmi_watchdog
> 
> * suspend to disk
> 
> Now when you resume, you should either see unknown reason 2c or 3c.

Oh, this reminds me that this time it might be unrelated to yesterday's
use of ethernet. Because today, I resumed the system by a kernel which I
didn't pass nmi_watchdog=0 to.

Hmm. So you can silently ignore the report I sent today :).

And sure, the way you describe above "works" for me to trigger the
issue... I just wanted to note the ethernet may interfere.

Anyway, I will bake some hack to disable NMI before jumping to the
resumed kernel and will see what happens...

-- 
js
suse labs
