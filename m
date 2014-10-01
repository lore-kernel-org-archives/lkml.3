Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaJAOOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:14:30 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60770 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJAOO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:14:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
Date: Wed, 01 Oct 2014 16:14:20 +0200
Message-ID: <6852466.Q5TXcWChqW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001140441.GF1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2043842.LxdgdYRbIF@wuerfel> <20141001140441.GF1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8cRqRKBMFff2QMe8aqKNq34dKlvcAQp+lx8wGbmND1u
 VtXEyM8ad2n7BZ3ExVfhjRh6GtWS50zeUV+9WZbzb2EC9iBnVV
 pVje2OrVYc40BkWHBnLwRl1nXr8/6xlAsUz9/Y60ssjv+i4AUq
 4khZK88as1p0ymIqjfXxKdZwwvIkdUqeUIEg5oOlKLaWI+BWkQ
 lg7LU0Tg1HiAOgcrmoc4dKanwbW8vb1QKNMJJ2jenpxEhhdAs0
 WaJWy0cXXQYXfgtrG3T1k+5uerOMkaSF+sj7ALXaj2Hk/xMKks
 22RFj45P/ZeNiJ4MLTE9i068+DP5Uh3PuR0FfFHfR4A9wSnmcW
 inW5Jg3Gq1deZM7N6GQ8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 17:04:41 Mika Westerberg wrote:
> 
> > On the question what to put into the name and type fields, that is
> > unrelated. The type is supposed to be for the 'device_type' property
> > in DT, which we should never rely on in a driver that supports both
> > APCI and DT. In Linux we only use that for "pci", "cpu" and "memory",
> > all of which have their own way of getting probed in ACPI.
> > The "name" is normally ignored in DT as well, except for backwards
> > compatibility with old bindings, but I would argue that you should not
> > just put "prp0001" in there. Either leave it empty like type, or use
> > the name of the device as it appears in the ACPI tables, such as "DEV0"
> > or "PWM".
> 
> OK, I think it makes sense to leave them empty. I remember I tried that
> at some point but it didn't work without N and T fields. Is there some
> example what to put there in case of empty?
> 
> Something like "of:N*T*Cgpio-leds" perhaps?

Sorry, don't know. If I read the code right, the type field in DT ends
up being "<NULL>" for any device that doesn't set the device_type 
property, but that seems a bit silly and probably isn't worth copying.

	Arnd
