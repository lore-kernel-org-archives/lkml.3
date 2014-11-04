Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKDFy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:54:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKDFyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:54:25 -0500
Date: Mon, 3 Nov 2014 21:54:19 -0800
From: Darren Hart <dvhart@infradead.org>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Giedrius Statkevicius <giedriuswork@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v2] platform: hp_accel: add a i8042 filter to remove
 HPQ6000 data from kb bus stream
Message-ID: <20141104055418.GA56751@vmdeb7>
References: <1414688267-29676-1-git-send-email-giedriuswork@gmail.com>
 <5456ADF2.8080400@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5456ADF2.8080400@tremplin-utc.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 11:19:30PM +0100, Éric Piel wrote:
> On 30-10-14 17:57, Giedrius Statkevicius wrote:
> >Add a i8042 filter to hp_accel to remove accelerometer's data with acpi
> >id HPQ6000 from keyboard bus stream. The codes sent by accelerometer are
> >e0 25, e0 26, e0 27 and e0 28. The relevant information is already
> >passed through /dev/freefall so no need to send these undocumented weird
> >signals through the keyboard bus. Also, unclogs `dmesg` because atkbd
> >complained about weird scan codes, saves processing power and disk
> >space.
> >
> >Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
> >Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Hi,
> Looks fine with respect to the hp accel driver. If Dmitry thinks the
> behaviour is fine then I've got nothing more to say :-)
> 
> Reviewed-by: Éric Piel <eric.piel@tremplin-utc.net>
> 
> Darren, could you pick up this patch in your tree?

Yes, applied. It will make my 3.18-3 series to Linus by the end of the week, I
want it to spend a few days in next first.

> 
> Cheers,
> Éric
> 
> 
> >---
> >Changes in v2:
> >* Remove a unnecessary deletion of a blank line
> >* Move #includes of i8042.h and serio.h before the relative path
> >   includes.
> >
> >First of all, any Tested-Bys are very welcome by people who also have a
> >accelerometer with acpi id HPQ6000. If it happens with HPQ6007 too we
> >can easily modify this to install the filter when HPQ6007 is detected.
> >For the time being the filter is only installed when HPQ6000 is
> >detected.
> >
> >Now moving to what was changed since the RFC. I reworked the filter
> >function to hopefully make it more clear what it is doing. Since the
> >codes sent by the accelerometer are extended then we need to filter all
> >of 0xe0's and then send one 0xe0 back when the actual key isn't in the
> >range of 0x25-0x28. Also, I've removed the check for errors for
> >i8042_install_filter() because it's unnecessary to check if it failed.
> >If multiple HPQ6000's are in the system then no issue occurs even if
> >multiple i8042_install_filter() are issued because this is handled by
> >i8042 and it's smart enough not to install the same filter two or more
> >times.
> >
> >This fixes https://bugzilla.kernel.org/show_bug.cgi?id=84941.
> :
> 

-- 
Darren Hart
Intel Open Source Technology Center
