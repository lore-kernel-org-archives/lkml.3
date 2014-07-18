Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbaGRQRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:17:33 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:51635 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761729AbaGRQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:17:31 -0400
Date: Fri, 18 Jul 2014 13:16:36 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        George Cherian <george.cherian@ti.com>,
        linux-arm-kernel@lists.infradead.org, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/9] usb: musb: several bugfixes for the musb driver
Message-ID: <20140718161636.GA18460@arch.cereza>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

On 18 Jul 11:31 AM, Lothar Waßmann wrote:
> The first three patches do some source code cleanup in the files that
> are modified in the subsequent patches.
> 

I've applied patches 4 and 9 on a recent -next, after fixing a conflict
due to patch 3 ("usb: musb_am335x: source cleanup"):

> Patch 4 carries the proper fix reported in commit:
>         7adb5c876e9c ("usb: musb: Fix panic upon musb_am335x module removal")
> 
> Patch 9 reinstates module unloading support for the musb_am335x driver
>         which was disabled due to a false failure analysis
> 

For these two patches, Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

Tested on a beaglebone with a mass storage USB device, module load/unload
works without issues. The module_get/put in the phy is now preventing the
musb_am335x driver unload, which seems to be the real cause of the issue
I reported. Thanks for providing a proper fix!
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
