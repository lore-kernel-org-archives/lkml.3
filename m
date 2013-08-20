Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3HTF2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:28:49 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:59315 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab3HTF2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:28:48 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 87F2DCBC4C
Date: Tue, 20 Aug 2013 07:28:46 +0200 (CEST)
From: screamingfist@arcor.de
To: gregkh@linuxfoundation.org, erazor_de@users.sourceforge.net
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <855534750.937448.1376976526543.JavaMail.ngmail@webmail11.arcor-online.net>
In-Reply-To: <20130815164024.GB15688@kroah.com>
References: <20130815164024.GB15688@kroah.com> <1376582626.2452.26.camel@neuromancer.tessier-ashpool>
Subject: Aw: Re: [PATCH 35/36] hid: roccat: convert class code to use
 bin_attrs in groups
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 138.246.2.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Nachricht ----
Von:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
An:      Stefan Achatz <erazor_de@users.sourceforge.net>
Datum:   15.08.2013 18:40
Betreff: Re: [PATCH 35/36] hid: roccat: convert class code to use bin_attrs
 in groups

> On Thu, Aug 15, 2013 at 06:03:46PM +0200, Stefan Achatz wrote:
> > Hello Greg,
> > looking through the patch I found the following:
> > 
> > 
> > 
> > In hid-roccat-kone.c, PROFILE_ATTR macro:
> > The line
> >  .private = &profile_numbers[number],
> > should read
> >  .private = &profile_numbers[number-1],
> 
> Ah, ok, thanks, will fix up.
> 
> > Regarding the compiler warning about unused pyra_sysfs_write_settings:
> > The attribute is indeed readwrite, but the code to write is not standard
> > code. The read function was created with the PYRA_SYSFS_R macro and the
> > write function was written manually. Used were both by
> > PYRA_BIN_ATTRIBUTE_RW.
> > In this case I would keep the PYRA_SYSFS_* macros standalone so that the
> > calling code looks like this:
> > 
> > PYRA_SYSFS_W(control, CONTROL);
> > PYRA_SYSFS_RW(info, INFO);
> > PYRA_SYSFS_RW(profile_settings, PROFILE_SETTINGS);
> > PYRA_SYSFS_RW(profile_buttons, PROFILE_BUTTONS);
> > PYRA_SYSFS_R(settings, SETTINGS);
> > 
> > PYRA_BIN_ATTRIBUTE_W(control, CONTROL);
> > PYRA_BIN_ATTRIBUTE_RW(info, INFO);
> > PYRA_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS);
> > PYRA_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS);
> > PYRA_BIN_ATTRIBUTE_RW(settings, SETTINGS);
> 
> Hm, I'll look this over again and see if I can make it better.
> 
> But why are you using a "non standard" write function?  What is special
> here about this?

The module stores the written value, so that events from the device can be
written to chardev with this extra information.
I made the mistake to put too many functionality in the early kernel modules
and I'm not getting fully rid of it now.

> > Another thing: Why does nobody (besides me) use the get_maintainer.pl
> > script, so I have to search manually for patches regarding my code?
> 
> I did use it:
> 
> $ ./scripts/get_maintainer.pl --file drivers/hid/hid-roccat-kone.c 
> Jiri Kosina <jkosina@suse.cz> (maintainer:HID CORE LAYER)
> linux-input@vger.kernel.org (open list:HID CORE LAYER)
> linux-kernel@vger.kernel.org (open list)
> 
> You aren't listed there, perhaps a MAINTAINERS entry needs to be added?

I thought get_maintainer spits out my name when doing my own patches...
I'll add myself to this list then.

> thanks,
> 
> greg k-h

Have a nice day
Stefan
