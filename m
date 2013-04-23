Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3DWUO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:14:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3DWUO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:14:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCH 14/21] staging: nvec: allow modular build
Date: Tue, 23 Apr 2013 22:14:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <201304232141.04123.arnd@arndb.de> <1373204.GiWOFfjzyB@ax5200p>
In-Reply-To: <1373204.GiWOFfjzyB@ax5200p>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232214.18254.arnd@arndb.de>
X-Provags-ID: V02:K0:/3vp2kWmlpLN2thBWmQ3nPeSsvKAohDRIzVNaNdGW3S
 SqWJ7sLmlnmJ9nghVq4Ph/746JBOvg/wgb1KDYCXNIKYCxC/GU
 UKxpyHqPvGjSFWa5bW0XHeKAK30yFB4DibRaWhqhVdbLuJrRr8
 4enHXkGw2Z1LfyUoREmzw1ER7QsGtwk8/YpQnLkN8COCzYQ6GE
 QjvLTadLWIPFb47NWQ2jYiSdLaVWqc+aA87MbbxKjnWaoLjfmr
 q1Qr7+ltVaRffzjPtZ36qvOCtpdspShunbjKSEfpZnXkCAw3id
 cKH0Ndl8PTPn+Tf8QTg2heznIiNWyBedO0/vaoJ9bzOXif/+si
 UwQvBMCx6mFxLq7tsJts=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Marc Dietrich wrote:
> It builds, but I haven't tried out it yet. At least the mfd children need to 
> unregister the event notifier I guess. Anyway, I have no time to test this 
> now, so I prefer to force =y for the dependencies for now.

Ah, so you can load it fine, but not safely unload it? In that case I think
it's better to leave it as tristate but remove the module_exit() function to
prevent unloading.

You'll have to change the module_platform_driver() back into a manual
module_init() function to register the driver, but that sounds like
the cleanest solution aside from fixing the notifier calls.

	Arnd
