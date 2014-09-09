Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaIIAEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:04:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaIIAEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:04:39 -0400
Date: Mon, 8 Sep 2014 17:04:30 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
Message-ID: <20140909000429.GB5835@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
 <20140906024253.GB11389@vmdeb7>
 <CAGdLNWGhdQU3Fpud9Zgvx3AQ5Lb=WdEkJb_wWTb1hJoHxXPXpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdLNWGhdQU3Fpud9Zgvx3AQ5Lb=WdEkJb_wWTb1hJoHxXPXpQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:04:18PM -0600, Azael Avalos wrote:
> Hi there,
> 
> 2014-09-05 20:42 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> > On Fri, Sep 05, 2014 at 11:14:05AM -0600, Azael Avalos wrote:
> >> The accelerometer sensor is very sensitive, and having userspace
> >> poll the sysfs position entry is not very battery friendly.
> >>
> >> This patch removes the sysfs entry and instead, it creates an
> >> input polled device (joystick) for the built-in accelerometer.
> >
> > Hrm, while sysfs details can change across kernel versions, usually due to
> > driver core changes, we try to keep them as consistent as possible so as not to
> > break userspace.
> >
> > That said, if we are going to try and come up with a better model for
> > representing an accelerometer, wouldn't treating it as an IIO device be the more
> > logical approach?
> 
> Yes of course, but the actual accelerometer device (sensor?) is not
> really exposed,
> only certain "functions" it provides, and they are divided across two
> different ACPI devices,
> TOS620A exposes the protection, and the TOS1900 (and et. al.) only
> exposes the axes.

As I understand it, IIO defines an interface to a device, a standard sysfs set
of properties. I should think we could provide the appropriate callbacks even
for a partially implemented (or a pair of) accelerometer.

Jonathan, what are your thoughts here. Is such a "device" (ACPI accessors to
axis and threshold) a candidate for IIO, or is this input polled device more
appropriate?

> 
> I see your point in breaking userspace, but given the fact that it was
> recently introduced,
> I didn't thought it was already "adopted", that's why I decided to
> remove the sysfs entry.

Looks like since 3.15 if I read the log correctly. That is fairly recent and
this is not one of the "defined interfaces" in the sysfs documentation.

Greg, can you weigh in here - does this change count as "breaking userspace", or
is this more inline with the scheduler knobs in /proc/sched_debug which can
change from version to version.

> 
> Then we might as well keep the sysfs entry and have the input polled
> device as well.

Let's see what Greg has to say. If he isn't bothered by the change, I won't push
the issue.

-- 
Darren Hart
Intel Open Source Technology Center
