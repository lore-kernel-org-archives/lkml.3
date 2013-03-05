Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3CEIcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:32:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab3CEIcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:32:18 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>, zihan@huawei.com,
        Lin.Lei@huawei.com, Greg KH <gregkh@linuxfoundation.org>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
Date: Tue, 05 Mar 2013 09:32:32 +0100
Message-ID: <4661149.JOvxeICSJy@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.8.0-rc7-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5135201F.4030200@draisberghof.de>
References: <87obezs888.fsf@nemi.mork.no> <87wqtnq8bb.fsf@nemi.mork.no> <5135201F.4030200@draisberghof.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 March 2013 23:28:47 Josua Dietze wrote:
> > I guess the real problem will be verifying that all of the entries can
> > go away. This type of hardware tends to get old very fast, but there is
> > always someone having a really ancient device.
> 
> I will check this and add any missing USB IDs to usb_modeswitch, but I can't shake the feeling that not all Huawei entries in "unusual_devs.h" did actually materialize as devices ...
> 
> Anyway, as Bjørn said, putting that initialization into the storage driver takes away quite some possibilities to handle these modems in a flexible way.

But it adds the ability to handle loss of power in the suspend case
cleanly. As long as the switch only makes additional devices appear,
doing it in kernel space is the nicer approach.

	Regards
		Oliver

