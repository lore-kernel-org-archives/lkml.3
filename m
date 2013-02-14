Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab3BNLJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:09:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934147Ab3BNLJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:09:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
Date: Thu, 14 Feb 2013 11:08:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: anish singh <anish198519851985@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <201302140956.36843.arnd@arndb.de> <20130214100452.GF17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130214100452.GF17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302141108.41597.arnd@arndb.de>
X-Provags-ID: V02:K0:6kCPltxjbvHgnsSit65ZDzuv1SZU7a13uhz/o3a5BDQ
 HVZngnsDfFbRTUb7j5r99j7uHaDUMRZY9n8lBvYWgap3/QEDEK
 YJCcl6Ff5lEIiB73ymAoIcuYQ/l38tysVnxS8lpB9qR/sovEZx
 EdKHzDLxXczV/LtrF3n70sYt5DNX1gtM1khg8fkGrk3KlRtU9B
 zV23BeYKYCz2tcdSqv2Tfe5koLjKBoKTYNtkzb01NeoWIMEi6I
 cL4r8buSbQe2HshLixLf7uaVadZOGQI8tu4lREmL6Qg+oisMDU
 6vKMe8c3JGz6yaPKZbzJLKc4iRMxwfQY6ppMRBwlvz+f1AxW7X
 tr/g8hlOheCXhPHMQx4Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Russell King - ARM Linux wrote:
> In the general case, that remains true, but it's still not true for
> console drivers.
> 
> The console should be initialised before it is attempted to be opened
> before passing control to userspace, which happens before the .init
> section is freed.

Yes, I forgot about that. This is indeed an additional requirement
besides what I listed. The late_initcall in which Grant was adding
the serialization however is executed just before the /dev/console
gets opened, which seems like an appropriate place.

What might get into the way is that other late_initcalls get
executed after this one and are required for the console. In
that case, we would have to move the deferred_probe_initcall
from a late_initcall to the end of do_basic_setup, after all
the other initcalls.

	Arnd
