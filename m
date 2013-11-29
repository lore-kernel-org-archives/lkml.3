Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3K2C3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:29:24 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:33261 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3K2C3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:29:22 -0500
Message-ID: <5297FBF6.2060802@gtsys.com.hk>
Date: Fri, 29 Nov 2013 10:29:10 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb: chipidea: hw_phymode_configure moved before
 ci_usb_phy_init
References: <1385690880-32303-1-git-send-email-chris.ruehl@gtsys.com.hk> <CAOMZO5DZ2AtM-6m9C54hEi60V=c95HzYaNW6YkiZjBy+8QWfaw@mail.gmail.com>
In-Reply-To: <CAOMZO5DZ2AtM-6m9C54hEi60V=c95HzYaNW6YkiZjBy+8QWfaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio

On Friday, November 29, 2013 10:14 AM, Fabio Estevam wrote:
> Hi Chris,
>
> On Fri, Nov 29, 2013 at 12:08 AM, Chris Ruehl<chris.ruehl@gtsys.com.hk>  wrote:
>> hw_phymode_configure configures the PORTSC registers and allow the
>> following phy_inits to operate on the right parameters. This fix a problem
>> where the UPLI (ISP1504) could not detected, because the Viewport was not
>> available and returns 0's only.
>>
>> Signed-off-by: Chris Ruehl<chris.ruehl@gtsys.com.hk>
>
> I have already fixed this issue. It is in mainline now:

yeah, the hw_phymode_configure() was in the probe but not called before the
ci_usb_phy_init(ci) which triggers the inits in phy-generic.c (in my case)

My pending patches relay on this.

Did you move the hw_phy before the ci_usb_phy_init too ?

Chris


>
> commit 03779f05be6dfc48de99763f6c845a003e1e40f3
> Author: Fabio Estevam<fabio.estevam@freescale.com>
> Date:   Wed Aug 14 12:43:56 2013 +0300
>
>      usb: chipidea: move hw_phymode_configure() into probe
>
>      Currently hw_phymode_configure() is located inside hw_device_reset(), which
>      only called by chipidea udc driver.
>
>      When operating in host mode, we also need to call hw_phymode_configure() in
>      order to properly configure the PHY mode, so move this function into probe.
>
>      After this change, USB Host1 port on mx53qsb board is functional.
>
>      Signed-off-by: Fabio Estevam<fabio.estevam@freescale.com>
>      Tested-by: Arnaud Patard<arnaud.patard@rtp-net.org>
>      Reviewed-by: Peter Chen<peter.chen@freescale.com>
>      Signed-off-by: Alexander Shishkin<alexander.shishkin@linux.intel.com>
>      Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>
> Regards,
>
> Fabio Estevam

-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
