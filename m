Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3BRKNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:13:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab3BRKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:13:43 -0500
From: Arnd Bergmann <arnd@linaro.org>
Organization: Linaro Ltd
To: Bo Shen <voice.shen@atmel.com>
Subject: Re: [V2 2/8] USB: EHCI: make ehci-atmel a separate driver
Date: Mon, 18 Feb 2013 10:12:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Manjunath Goudar <manjunath.goudar@linaro.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "Andrew Victor" <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
References: <1360923853-7875-1-git-send-email-manjunath.goudar@linaro.org> <1360923853-7875-3-git-send-email-manjunath.goudar@linaro.org> <5121F80E.1010501@atmel.com>
In-Reply-To: <5121F80E.1010501@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302181012.44721.arnd@linaro.org>
X-Provags-ID: V02:K0:lxswPM1DVdHeJKaWHHFnllkYHoZ69kCY9VqEKze7d/Q
 xm6Yaeu81wTQfR+j9aKInTuF+bvmgQrq4pJ5dM8AnEZ1MuVvo6
 kfLDQaYd3mTeK55497du0MIxuyfFXItPgUKbMRsbtsmCBpEb67
 wJ2VKbKy3fY+PDJCUPhOM0UrgzhE2CvNDCBXTsmibXWk1xYG4P
 SSzK6YFmrP1F3ijnbYB9EJE06eHceA3FsyPtYga1O/LvMdfRe2
 QxqoXHsX0Ia7xB43KZH0Ep22Y4fBbq3ub6OkUJElbwb0rsyNEG
 mItoN7LHrgSCNngwCb0rkBpMAZeSkqReTc6NcRKdAs856idd74
 sS5R4lgo3MPWbJzmo8jc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013, Bo Shen wrote:
> > -             .name   = "atmel-ehci",
> > +             .name   = hcd_name,
> 
> This change will cause atmel ehci won't work with the none device tree 
> kernel.
> 
> it can be fixed with replace other places using "atmel-ehci" with 
> <hcd_name>, that means replace "atmel-ehci" with "ehci-atmel" at other 
> places.

Ah, that is right. Thanks for pointing it out!

Manjunath, please revert this change and ensure you are not changing
the contents of the 'platform_driver->name' field in any of the drivers.

	Arnd
