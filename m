Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3GUTrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 15:47:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:55891 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3GUTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 15:47:51 -0400
Message-ID: <51EC3AE0.5020107@linutronix.de>
Date: Sun, 21 Jul 2013 21:47:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        George Cherian <george.cherian@ti.com>,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-omap@vger.kernel.org,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH] of: provide of_platform_unpopulate()
References: <1374257691-31981-1-git-send-email-bigeasy@linutronix.de> <51EBF33A.4050207@gmail.com>
In-Reply-To: <51EBF33A.4050207@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 04:42 PM, Rob Herring wrote:
> Wouldn't the correct fix be to call insert_resource somehow?

Yes unless there was a reason this wasn't done in the first place.

> The problem
> I have is that while of_platform_populate is all about parsing the DT
> and creating devices, the removal side has nothing to do with DT. So
> this should not be in the DT code. I think the core device code should
> be able to handle removal if the device creation side is done correctly.

If there is no need to use the special removal function (in case we add
insert_ressource) then yes. What about a pointer in
of_platform_populate()'s comment referring to the removal function?

> 
> It looks to me like of_device_add either needs to call
> platform_device_add rather than device_add. I think the device name
> setting in platform_device_add should be a nop. If not, a check that the
> name is already set could be added.

It does actually the same thing as platform_device_add except the
"dynamic device id" and the resource insert if I remember correctly. If
you guys prefer the platdorm_device_add() path including
insert_ressource() I can try this.

> 
> Rob

Sebastian
