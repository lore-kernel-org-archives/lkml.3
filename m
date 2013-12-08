Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab3LHOGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:06:33 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44863 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260Ab3LHOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:06:13 -0500
Message-ID: <52A47CCC.50000@linux.com>
Date: Sun, 08 Dec 2013 15:06:04 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Davis <alex14641@yahoo.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: add parameter to disable the backlight device.
References: <1386510031.81267.YahooMailNeo@web160401.mail.bf1.yahoo.com>
In-Reply-To: <1386510031.81267.YahooMailNeo@web160401.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2013-12-08 14:40, Alex Davis:
> I have a Dell Inspiron N7010 Laptop with Intel graphics. When the dell-laptop module is loaded,
> two backlight device devices are created; dell_backlight, and intel_backlight from the Intel
> graphics driver. The dell_backlight device is non-functional, but the graphics subsystem uses
> it instead of the functioning intel_backlight device. The result is that, when running KDE,
> screen brightness cannot be controlled. I've added a module parameter, disable_backlight
> which, when true, will disable the dell_backlight device, and leave only the intel_backlight:
> with this, screen brightness can be controlled.
>

Hi,

I think it would be better if we could figure out why the
dell_blacklight device is not working rather than disabling it.


Regarding your patch, it creates a memory leak as you:
  * allocate a platform device
  * you add it
  * you allocated a page for SMI

Your if(disable_blacklight) code should go
where it checks the DMI.

-- 
Regards,
Levente Kurusa
