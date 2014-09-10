Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaIJQJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:09:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaIJQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:08:59 -0400
Date: Wed, 10 Sep 2014 09:08:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
Message-ID: <20140910160858.GB16596@kroah.com>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
 <20140906024253.GB11389@vmdeb7>
 <CAGdLNWGhdQU3Fpud9Zgvx3AQ5Lb=WdEkJb_wWTb1hJoHxXPXpQ@mail.gmail.com>
 <20140909000429.GB5835@vmdeb7>
 <20140909013553.GC16363@kroah.com>
 <20140910033520.GC39541@vmdeb7>
 <CAGdLNWEgJmNQ_F7kozn4tGCq_AseuE95xHKoxTWgtNqdBwSm5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdLNWEgJmNQ_F7kozn4tGCq_AseuE95xHKoxTWgtNqdBwSm5A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:28:44AM -0600, Azael Avalos wrote:
> Hi there,
> 
> 2014-09-09 21:35 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> >
> > I immediately went to a tablet with a marble maze game and it didn't seem too
> > crazy, but I don't suppose that is what people are actually doing with it...
> >
> > What are people actually doing with this thing Azael?
> 
> Gaming mostly (supertuxkart anyone?), but some others (including myself)
> want to use it as a movement detection (one exists for the IBM/Lenovo
> Thinkpads).
> 
> Digging into platform drivers, I've found that the hdaps and also the lis3lv02d
> drivers report the axes via polldev, and since I don't want to break userspace,
> I'm left with two choices:
> 
> 1 - Keep sysfs entry and adapt it to properly report direction, and no
> polled device.
> 
> 2 - Keep sysfs entry and adapt it to properly report direction, and also
> a polled device.
> 
> Let me know your decision so I can send an updated patch.

3 - use the correct api and change it to iio so that all userspace tools
can correctly interact with it, instead of dealing with a
driver-specific sysfs file.

thanks,

greg k-h
