Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3HGJCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:02:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43870 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3HGJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:02:34 -0400
Message-ID: <52020D53.1030305@gmail.com>
Date: Wed, 07 Aug 2013 17:03:15 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-acpi@vger.kernel.org,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl, Aaron Lu <aaron.lu@intel.com>
Subject: Re: Backlight control only in the kernel?
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <20130807074405.GA18272@pd.tnic>
In-Reply-To: <20130807074405.GA18272@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:44 PM, Borislav Petkov wrote:
> On Sun, Jun 09, 2013 at 07:01:36PM -0400, Matthew Garrett wrote:
>> Windows 8 introduced new policy for backlight control by pushing it out to
>> graphics drivers. This appears to have coincided with a range of vendors
>> adding Windows 8 checks to their backlight control code which trigger either
>> awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
>> thing to do would be to just disable ACPI backlight control entirely if the
>> firmware indicates Windows 8 support, but it's entirely possible that
>> individual graphics drivers might still make use of the ACPI functionality in
>> preference to native control.
> 
> Maybe tangential, so Aaron and I were wondering on
> https://bugzilla.kernel.org/show_bug.cgi?id=60680 whether it would make
> sense to handle the backlight control strictly in the kernel, without
> going to userspace and back?

I think this would require the kernel has the knowledge of which
backlight interface this system is using or should be using, or it
wouldn't know which interface should receive and process the event...

-Aaron

> 
> Background is that on my x230, I needed to connect the
> Fn-Fx backlight hotkey presses to a script to write to
> /sys/class/backlight/intel_backlight/brightness because Fluxbox doesn't
> do that (and maybe doesn't have to).
> 
> So, without presuming any ACPI or backlight knowledge, can we make the
> backlight control work only in the kernel by connecting the hotkey
> presses to some backlight controlling interface which backlight-capable
> devices implement so that it works regardless of userspace environment?
> Even if the machine is not running X?
> 
> Hmmm.
> 
> Thanks.
> 

