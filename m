Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaHFVTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:19:15 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59321 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaHFVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:19:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Subject: Re: [PATCH v3 0/6] Add EHCI and OHCI drivers for STi SoC's
Date: Wed, 6 Aug 2014 23:18:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201408062318.28958.arnd@arndb.de>
X-Provags-ID: V02:K0:KEIJ2S2HpYmFpYZUI5w8ylbx/PIUjzkrcVf3j4bXmuO
 sD9q7cml9+VEIMYK1jEeOLkftPvz9eArOmQiId8Xsahkhrc36W
 mLoksgBYkA3QIMeHMKNeTDeVQOmUMj5UuF0CFbA/m8Ra5vsFXV
 mHCbQrZyRksHGHh5KrFg6IoHt88+lRmmZgHPa1iYZJVdyesig6
 lGVQUXfozD3A3wFogxpwb54StjuL4wf24QPFrcBmMfKGUv7lq8
 ROdPcqcSJMIqHXRBy3UqUQa50cyqW+wuYyznHhcBbqJR2ERmdF
 RFjzzoX3TlfMkNZoZUObaILKQy7y1+COm+beozaeHQLqAolohz
 QWhig8WtNtnxeHo5a36alIlJ2EnF3MUn8MSbr34pN
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2014, Peter Griffin wrote:
> This series adds support for the OHCI and EHCI on-chip controllers
> found in STi consumer electronics SoC's from STMicroelectronics.
> 
> The series has been re-worked from v2 to split out the ehci and ohci parts
> into their own drivers / devices like most other ARM platforms based on
> feedback from Arnd Bergmann (see here http://www.spinics.net/lists/linux-usb/msg111124.html. 
> 
> The ehci-platform & ohci-platform have been used as a basis for this in case we
> wish to merge the drivers again in the future.
> 
> Changes since v2:
>  - Based on Arnd Berghman feedback, split out into 2 devices / drivers
>  - Base drivers oh ehci-platform.c & ohci-platform.c with required extensions
>    to allow possible re-merge in the furture.

Hi Peter,

This looks much better than the first version. I have some remaining comments for
how it could be simplified a bit more.

The way that you deal with the 48mhz clock seems like it should fit in well
with the generic driver, just like all the rest (once the usb-st-common
stuff is moved into the ohci/ehci drivers), so the alternative would be
to make it all generic now.

	Arnd
