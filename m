Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaK0QAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:00:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaK0QAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:00:02 -0500
Date: Thu, 27 Nov 2014 07:58:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Kalle Valo <kvalo@adurom.com>,
        Sebastian Reichel <sre@ring0.de>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: wl1251: NVS firmware data
Message-ID: <20141127155840.GC24149@kroah.com>
References: <201411271506.20457@pali>
 <201411271543.23527@pali>
 <20141127151655.GB23064@kroah.com>
 <201411271622.58916@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411271622.58916@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 04:22:58PM +0100, Pali Rohár wrote:
> On Thursday 27 November 2014 16:16:55 Greg Kroah-Hartman wrote:
> > On Thu, Nov 27, 2014 at 03:43:23PM +0100, Pali Rohár wrote:
> > > On Thursday 27 November 2014 15:21:44 Ming Lei wrote:
> > > > On Thu, Nov 27, 2014 at 10:06 PM, Pali Rohár
> > > 
> > > <pali.rohar@gmail.com> wrote:
> > > > > Hello,
> > > > > 
> > > > > wifi driver wl1251 needs NVS calibration data for
> > > > > working. These data are loaded by driver via
> > > > > request_firmware from userspace file:
> > > > > ti-connectivity/wl1251-nvs.bin. In linux-fimrware git
> > > > > tree there is generic wl1251-nvs.bin file which is used
> > > > > by default.
> > > > > 
> > > > > Driver wl1251 is used on Nokia N900 cellphone for its
> > > > > wifi chip. This cellphone has one special MTD partition
> > > > > (called CAL) where are stored some configuration data
> > > > > in special binary (key-value) format. And there is also
> > > > > stored correct calibration data for specific device
> > > > > (each device has different data). It is preferred to
> > > > > use those data instead generic one (provided by
> > > > > linux-firmware git tree).
> > > > > 
> > > > > Now my question is: How to correctly load calibration
> > > > > data from special Nokia N900 CAL partition into wl1251
> > > > > kernel driver?
> > > > 
> > > > It is better to let user space script handle the request.
> > > 
> > > Yes, this makes sense. Implementing CAL parser in kernel
> > > wl1251 driver would be hard...
> > > 
> > > > > By default kernel reads ti-connectivity/wl1251-nvs.bin
> > > > > file from VFS if exists without any userspace support.
> > > > > If it fails then it fallback to loading via udev.
> > > > 
> > > > You can remove or rename this file so that loading from
> > > > user space can be triggered.
> > > 
> > > It is no so easy... In case when CAL does not contains NVS
> > > data then we want to use this generic NVS file. And telling
> > > everybody to rename this is file is not good solution...
> > 
> > But that's up to your system configuration, not the kernel. 
> > Make a userspace package for the firmware that creates it in
> > the format you need it to be in, for the hardware you have,
> > and then there would not be any need for a kernel change,
> > right?
> > 
> > greg k-h
> 
> Not so simple as you think. Some parts of NVS data are configured 
> based on location and cellular station. Data are not static.

Then you need a dynamic program that you control, in userspace, to dump
the needed data into the kernel.  Don't try to do it with "static"
firmware files.  Use the binary sysfs file interface for this if you
want.

good luck,

greg k-h
