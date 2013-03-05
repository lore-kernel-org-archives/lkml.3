Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3CEEku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:40:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13753 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab3CEEkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:40:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 20:40:48 -0800
Message-ID: <5135774D.6080708@nvidia.com>
Date: Tue, 5 Mar 2013 13:40:45 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] pwm_bl: Add support for backlight enable GPIO
References: <1362433790-22560-1-git-send-email-achew@nvidia.com> <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de> <51355FA4.1090909@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629BFE1B02@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F7638629BFE1B02@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 01:00 PM, Andrew Chew wrote:
> I did come to the same conclusion regarding the platform data breakage.
> I'm expecting that the use of platform data will go away, at least on ARM,
> since we are all aggressively moving what used to be in platform data into
> the device tree.  Do other platforms use this driver?

I can see at least 29 users of platform_pwm_backlight_data, all ARM with 
the exception of one unicore32. I guess at least for the foreseeable 
future platform data will remain.

> I remember hearing that there is some work in progress to encapsulate
> gpios into a struct, rather than passing it around as a bare integer, so when
> that happens, we can use NULL for no-gpio, which should take care of the
> platform data issue as well.  It's kind of difficult to work around this problem
> otherwise.

Yes, actually I am doing the GPIO rework. If you are not too much in a 
hurry you might want for it to happen (should not be too long now that 
the core has been reworked). At the same time, GPIO descriptors will 
also enable the power sequences, so if you wait even longer (or help me 
with it), this patch might not even be needed at all. Of course if you 
want to support this *now*, this is still the shortest path.

> I agree that we should be turning on and off the backlight enable gpio as
> needed to save power.  I just haven't gotten there yet.  I can try to modify
> this patch if that's your preference, or I can follow up with a patch to add
> this in the very near future.

That's ultimately for Thierry to say, but submitting a new revision 
makes more sense IMHO - it is not a big change and there are other 
issues to address (uninitialized GPIO in platform data) anyway.

> To answer your last question, yes, this single patch does allow me to enable
> the backlight on some boards (in particular, the one I'm working on).

Cool - may I ask which one? All the NV boards I tried to far required 
more complex sequences for their panels.

Alex.

