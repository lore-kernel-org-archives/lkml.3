Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3CTKUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:20:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3CTKUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:20:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Wed, 20 Mar 2013 10:20:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <201303191759.27762.arnd@arndb.de> <CAHkwnC-3_dDM3JO8y3yeNFz7=fpP=MtZ9D-3cMH8rNF9C1NZBA@mail.gmail.com>
In-Reply-To: <CAHkwnC-3_dDM3JO8y3yeNFz7=fpP=MtZ9D-3cMH8rNF9C1NZBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303201020.14654.arnd@arndb.de>
X-Provags-ID: V02:K0:l1QWufT40kiwkWw61NsY3ogXUYtPWoEgT5s3imp+UXy
 Dqp+Viuy+Nyr9UE9F9GhI5H1CkKZpv9u48aYa6ZUO2nmqsaWjX
 Q4k5B12GZMfanbfzB6S/gPhkY26Q8AEm0T3DxM5lct5jKQaH0M
 5ITKWi81U/Jn52zw3OB6YzaeR+tjJ1RqYJkm8MTHadtxQHjA60
 up4ePmF8ckGUOPadSOngI0L4RG0GBMOzoG/nJzM5Z7x43JVRGV
 tHXERA9Tn6rBoaUAXo9k0fCWG//70d85wDUIMlXhEz3ZeDbWCP
 uTUiOrauDkizdsFri2kkyAKsF/5KTY7k9fbP01EKtsRC2hBNl6
 WfmdrMNhmLtqcFoYe5pw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013, Fabio Porcedda wrote:
> I think we can check inside the  deferred_probe_work_func()
> if the dev->probe function pointer is equal to platform_drv_probe_fail().

I think it's too late by then, because that would only warn if we try to probe
it again, but when platform_driver_probe() does not succeed immediately, it
unregisters the driver again, so we never get there.

	Arnd
