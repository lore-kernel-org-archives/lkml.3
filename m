Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaIQSiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:38:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaIQSiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:38:14 -0400
Date: Wed, 17 Sep 2014 11:38:09 -0700
From: Darren Hart <dvhart@infradead.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Azael Avalos <coproscefalo@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
Message-ID: <20140917183809.GA7517@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
 <20140906024253.GB11389@vmdeb7>
 <CAGdLNWGhdQU3Fpud9Zgvx3AQ5Lb=WdEkJb_wWTb1hJoHxXPXpQ@mail.gmail.com>
 <20140909000429.GB5835@vmdeb7>
 <10ee37dc-4645-48c4-9155-89b60b38f4cf@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10ee37dc-4645-48c4-9155-89b60b38f4cf@email.android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:36:31PM +0100, Jonathan Cameron wrote:
> 
> 
> On September 9, 2014 1:04:30 AM GMT+01:00, Darren Hart <dvhart@infradead.org> wrote:
> >On Fri, Sep 05, 2014 at 11:04:18PM -0600, Azael Avalos wrote:
> >> Hi there,
> >> 
> >> 2014-09-05 20:42 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> >> > On Fri, Sep 05, 2014 at 11:14:05AM -0600, Azael Avalos wrote:
> >> >> The accelerometer sensor is very sensitive, and having userspace
> >> >> poll the sysfs position entry is not very battery friendly.
> >> >>
> >> >> This patch removes the sysfs entry and instead, it creates an
> >> >> input polled device (joystick) for the built-in accelerometer.
> >> >
> >> > Hrm, while sysfs details can change across kernel versions, usually
> >due to
> >> > driver core changes, we try to keep them as consistent as possible
> >so as not to
> >> > break userspace.
> >> >
> >> > That said, if we are going to try and come up with a better model
> >for
> >> > representing an accelerometer, wouldn't treating it as an IIO
> >device be the more
> >> > logical approach?
> >> 
> >> Yes of course, but the actual accelerometer device (sensor?) is not
> >> really exposed,
> >> only certain "functions" it provides, and they are divided across two
> >> different ACPI devices,
> >> TOS620A exposes the protection, and the TOS1900 (and et. al.) only
> >> exposes the axes.
> >
> >As I understand it, IIO defines an interface to a device, a standard
> >sysfs set
> >of properties. I should think we could provide the appropriate
> >callbacks even
> >for a partially implemented (or a pair of) accelerometer.
> >
> >Jonathan, what are your thoughts here. Is such a "device" (ACPI
> >accessors to
> >axis and threshold) a candidate for IIO, or is this input polled device
> >more
> >appropriate?
> Absolutely fine in IIO.
> 
> Sorry I took so long to reply. Read the title and expected more detailed issue so queued
>  it up for when I had more time. Oops.
> 
> Only slight gotcha is that there is some debate over the iio timer trigger
>  configuration interface which would be equivalent of a polled input device.
> 
> Hence it hasn't merged yet.
> Comes down to how these are instantiated. Lars-Peter Clausen is planning a configfs
>  proposal rather than how we do the user space trigger creation currently.
> 
> A user space trigger would work but then you loose lack of hitting sysfs files.

Thanks Jonathan,

Azael, please follow-up with the IIO folks and if you want to modify the
interface, please do so via IIO so it uses a consistent interface and we can
eliminate these custom sysfs files.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
