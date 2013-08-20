Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3HTX6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:58:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3HTX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:58:12 -0400
Date: Tue, 20 Aug 2013 16:58:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: screamingfist@arcor.de
Cc: erazor_de@users.sourceforge.net, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 35/36] hid: roccat: convert class code to use
 bin_attrs in groups
Message-ID: <20130820235811.GA13887@kroah.com>
References: <20130815164024.GB15688@kroah.com>
 <1376582626.2452.26.camel@neuromancer.tessier-ashpool>
 <855534750.937448.1376976526543.JavaMail.ngmail@webmail11.arcor-online.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855534750.937448.1376976526543.JavaMail.ngmail@webmail11.arcor-online.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 07:28:46AM +0200, screamingfist@arcor.de wrote:
> ----- Original Nachricht ----
> Von:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> An:      Stefan Achatz <erazor_de@users.sourceforge.net>
> Datum:   15.08.2013 18:40
> Betreff: Re: [PATCH 35/36] hid: roccat: convert class code to use bin_attrs
>  in groups
> 
> > On Thu, Aug 15, 2013 at 06:03:46PM +0200, Stefan Achatz wrote:
> > > Hello Greg,
> > > looking through the patch I found the following:
> > > 
> > > 
> > > 
> > > In hid-roccat-kone.c, PROFILE_ATTR macro:
> > > The line
> > >  .private = &profile_numbers[number],
> > > should read
> > >  .private = &profile_numbers[number-1],
> > 
> > Ah, ok, thanks, will fix up.
> > 
> > > Regarding the compiler warning about unused pyra_sysfs_write_settings:
> > > The attribute is indeed readwrite, but the code to write is not standard
> > > code. The read function was created with the PYRA_SYSFS_R macro and the
> > > write function was written manually. Used were both by
> > > PYRA_BIN_ATTRIBUTE_RW.
> > > In this case I would keep the PYRA_SYSFS_* macros standalone so that the
> > > calling code looks like this:
> > > 
> > > PYRA_SYSFS_W(control, CONTROL);
> > > PYRA_SYSFS_RW(info, INFO);
> > > PYRA_SYSFS_RW(profile_settings, PROFILE_SETTINGS);
> > > PYRA_SYSFS_RW(profile_buttons, PROFILE_BUTTONS);
> > > PYRA_SYSFS_R(settings, SETTINGS);
> > > 
> > > PYRA_BIN_ATTRIBUTE_W(control, CONTROL);
> > > PYRA_BIN_ATTRIBUTE_RW(info, INFO);
> > > PYRA_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS);
> > > PYRA_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS);
> > > PYRA_BIN_ATTRIBUTE_RW(settings, SETTINGS);
> > 
> > Hm, I'll look this over again and see if I can make it better.
> > 
> > But why are you using a "non standard" write function?  What is special
> > here about this?
> 
> The module stores the written value, so that events from the device can be
> written to chardev with this extra information.
> I made the mistake to put too many functionality in the early kernel modules
> and I'm not getting fully rid of it now.

Ok, I've fixed this up now, so it all good, thanks for reviewing this.

greg k-h
