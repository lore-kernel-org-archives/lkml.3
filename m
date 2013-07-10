Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3GJUR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:17:28 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:53682 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab3GJUR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:17:27 -0400
Message-ID: <51DDC153.3080805@schinagl.nl>
Date: Wed, 10 Jul 2013 22:17:23 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: Driver core and sysfs changes for attribute groups
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/13 22:05, Greg Kroah-Hartman wrote:
> Hi all,
Hey Greg,

>
> Guenter and Oliver have been pointing out a few limitations of the
> driver core's ability to create files properly (i.e. in a way that
> doesn't race with userspace.)  The driver core allows this, but it
> doesn't export that ability to drivers very easily, and for binary
> files, not at all.
Exactly, even the patch you supplied didn't help, as it created the 
binary attributes for devices, not device_drivers or platform_drivers.

>
> So here's a set of 6 patches that I'll be queueing up to go to Linus in
> time for 3.11 so that people can start using them in their driver
> subsystems.  It adds some new macros to make using attributes and
> attribute groups easier, adds binary file capabilities to attribute
> groups, and finally, lets subsystems (like platform drivers) set a
> attribute group for when their device is created.
Oh, that does some like iceing on the cake.
>
> If anyone has any problems with these patches, please let me know.
>
I will try this patch set immediately and report back.

> Guenter, I've tweaked your original patch a bit, changing the name of
> the function and putting the kernel doc comments in the correct place so
> the build doesn't complain about it.
>
> I also have a set of follow-on patches, about 50+ big so far, that goes
> through the kernel and converts different drivers and subsystems to
> properly use attribute groups, instead of open-coding binary files and
> attributes.  Those patches will be sent out later, and will be for 3.12
> as they aren't needed at the moment, this infrastructure changes are
> needed first.
>
> thanks,
Thank you Greg, this is far more robust that what I cooked up (adding 
bin_attrs to struct device_driver. I was just going to send it to the 
list as well when I saw this message :)
>
> greg k-h
>

Oliver
