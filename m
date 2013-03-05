Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3CEOph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:45:37 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:18919 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3CEOpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:45:36 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.781
From: Lars Poeschel <poeschel@lemonage.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC] pwm: add sysfs interface
Date: Tue, 5 Mar 2013 15:46:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, thierry.reding@avionic-design.de,
        rob@landley.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de> <20130225040025.GB7911@kroah.com>
In-Reply-To: <20130225040025.GB7911@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303051546.13636.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At first: Thanks for your review!

On Monday 25 February 2013 at 05:00:25, Greg KH wrote:
> On Tue, Feb 19, 2013 at 03:27:41PM +0100, Lars Poeschel wrote:
> > +static int pwmchip_export(struct pwm_chip *chip)
> > +{
> > +	int status;
> > +	struct device *dev;
> > +
> > +	mutex_lock(&sysfs_lock);
> > +	dev = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> > +				"pwmchip%d", chip->base);
> > +	if (!IS_ERR(dev))
> > +		status = sysfs_create_group(&dev->kobj, &pwmchip_attr_group);
> > +	else
> > +		status = PTR_ERR(dev);
> 
> You can't create sysfs files after the device has been exposed to
> userspace.  Please use the default group functionality for the class,
> which fixes this problem.

I don't understand, what is wrong here. This is the same that gpio sysfs 
does. Could you please be a bit more specific ?
I create a new device using device_create and create a new group with it with 
some attributes. Isn't it exposed to userspace after that ?
Or am I not allowed to use pwm_class on device creation ? What to use then ?
What do you mean by default group functionality for the class ? I want to use 
my own "pwm" class ? Don't I ?

Regards,
Lars
