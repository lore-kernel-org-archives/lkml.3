Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3BCV3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:29:30 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:38667 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3BCV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:29:28 -0500
Message-ID: <510ED6B4.6000405@suse.cz>
Date: Sun, 03 Feb 2013 22:29:24 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <5109A8F1.9040707@suse.cz> <5109B11C.2010400@suse.cz> <5170962.qHnbnlVDfx@vostro.rjw.lan> <20130131070926.GC4926@pd.tnic> <510A2B1C.1060108@suse.cz> <20130131131805.GG4926@pd.tnic>
In-Reply-To: <20130131131805.GG4926@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 02:18 PM, Borislav Petkov wrote:
> On Thu, Jan 31, 2013 at 09:28:12AM +0100, Jiri Slaby wrote:
>> And, does it happen if you switch all of them but NMI wtd in there?
> 
> No, but something else happens. Here's the whole dance:
> 
> 1. Switch all tunables except "NMI watchdog should be turned off" to "Good"
> 2. suspend to disk
> 3. resume... all good
> 4. switch "NMI watchdog should be turned off" to "Good"
> 5. suspend to disk
> 6. resume... all good
> 7. start powertop, toggle "Wireless Power Saving for interface wlan0" twice.
> I.e., "Good" -> "Bad"; "Bad" -> "Good".
> 
> -> Boom! Unknown reason NMI. It happened right during the toggle because
> it appeared in the framebuffer console (no X) right during me toggling
> this.

Right, for me too. Even if I disable nmi watchdog in both the boot and
image kernel, the NMI eventually occurs (dunno what's the trigger now
though).

Given the above I'm thinking about switching that intel wi-fi card to
ath9k which I have at hand and retest...

-- 
js
suse labs
