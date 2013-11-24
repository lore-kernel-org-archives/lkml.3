Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3KXAkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:40:23 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43328 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253Ab3KXAkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:40:19 -0500
X-Sasl-enc: FuyFxTU9PrmARdODrP3JQ38rT/rKmw6UVc7UWGa/UhII 1385253617
Date: Sat, 23 Nov 2013 22:40:15 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-fbdev@vger.kernel.org, "'Kyungmin Park'" <kmpark@infradead.org>,
        kay@vrfy.org, Jingoo Han <jg1.han@samsung.com>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [ibm-acpi-devel] [PATCH] video: backlight: Remove backlight
 sysfs uevent
Message-ID: <20131124004015.GA19499@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
 <20131121114332.GA23710@khazad-dum.debian.net>
 <20131121143326.GA19773@srcf.ucam.org>
 <20131122113601.GB27196@khazad-dum.debian.net>
 <20131122171556.GA15680@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122171556.GA15680@srcf.ucam.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Matthew Garrett wrote:
> On Fri, Nov 22, 2013 at 09:36:01AM -0200, Henrique de Moraes Holschuh wrote:
> > On Thu, 21 Nov 2013, Matthew Garrett wrote:
> > > The uevent support was initially added to handle systems where pressing 
> > > a hotkey generates an event (good) but the firmware automatically 
> > > changes the brightness (bad). I have absolutely no idea why I added 
> > > BACKLIGHT_UPDATE_SYSFS - BACKLIGHT_UPDATE_HOTKEY solves the problem I 
> > > was trying to solve. I'm not aware of any userspace that relies on 
> > > BACKLIGHT_UPDATE_SYSFS.
> > 
> > Well, either we have userspace that rely on the uevents, or we don't. 
> 
> We have userspace that relies on uevents of type 
> BACKLIGHT_UPDATE_HOTKEY. I don't know that we have userspace that relies 
> on uevents of type BACKLIGHT_UPDATE_SYSFS.

Any OSD application would have to rely on both uevent types, or it is broken
(and to test that, just write a level to sysfs and watch the OSD app fail to
tell you about the backlight level change...)

I don't know about other types of applications, though.  What other type of
applications pay attention to backlight uevents?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
