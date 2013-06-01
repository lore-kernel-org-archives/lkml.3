Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3FAUEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:04:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3FAUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:04:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
Date: Sat, 1 Jun 2013 22:03:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-16-git-send-email-arnd@arndb.de> <CAL_Jsq+-7RizbVQSA-JnJRZFc9-3RFCXuCOXP=GfCin2Losfeg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+-7RizbVQSA-JnJRZFc9-3RFCXuCOXP=GfCin2Losfeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306012203.39133.arnd@arndb.de>
X-Provags-ID: V02:K0:j6YMU0IZsT79b9HWXbWMa899Q2+O9kUF+fMeW0fDeVX
 GxJhCz8aIo6vdx8LNaO3dosXfcy5eh/bxmfmWeUzh7GXed9Mwy
 KE8us5tLOHuGhdH7xhYvCRrvQ5WnhY0vt5oUc/cTwF289PkmJ1
 zOCm9nSxx8POpkKmU0GWC0wVllQd8WLbwuTgsdWvvoimTocfAd
 25/lTd8173x9zc4KsoNsQ+1Bx+d60VJuyWeZQW1Dy99O1u7HTx
 hpx9rL3ohP2fKb7qngmlqquPf16tRqqT/wP99kWRDR8Trk5PWo
 y/nboPkO19BiULsNPMAMNtU7GqeA5DBhxkwH92qbww8wa2Hvrb
 6sIrt1b1Rv+ucOjuxQUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 June 2013, Rob Herring wrote:
> On Fri, May 31, 2013 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > A lot of code uses the functions from of_platform.h when built for
> > devicetree-enabled platforms but can also be built without them.
> > In order to avoid using #ifdef everywhere in drivers, this
> > makes all the function declarations visible, which means we
> > can use "if (IS_ENABLED(CONFIG_OF))" in driver code and get build
> > coverage over the code but let the compiler drop the reference
> > in the object code.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> 
> I've got a more complete series for 3.11 that removes OF_DEVICE and
> of_platform_driver completely. I'm waiting on ack from Ben H.

Ok. Does your series also remove the #ifdef CONFIG_OF part from this
header?

	Arnd
