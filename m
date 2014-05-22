Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaEVO3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:29:48 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:56676 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbaEVO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:29:47 -0400
Message-ID: <537E09D6.7050604@itdev.co.uk>
Date: Thu, 22 May 2014 15:29:42 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rydberg@euromail.se,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 20/51] Input: atmel_mxt_ts - Set default irqflags when
 there is no pdata
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk> <1372337366-9286-21-git-send-email-nick.dyer@itdev.co.uk> <20130718171744.GC32381@polaris.bitmath.org> <20130916022533.GA6468@core.coreip.homeip.net>
In-Reply-To: <20130916022533.GA6468@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thu, Jul 18, 2013 at 07:17:44PM +0200, rydberg@euromail.se wrote:
>>> From: Yufeng Shen <miletus@chromium.org>
>>> This is the preparation for supporting the code path when there is
>>> platform data provided and still boot the device into a sane state
>>> with backup NVRAM config.
>>>
>>> Make the irqflags default to be IRQF_TRIGGER_FALLING if no platform data is
>>> provided.
> 
> I think if there is no platform data we should use 0 as IRQ falgs and
> assume that IRQ line is properly configured by the board code or via
> device tree.

Beson/Yufeng - do you still have a requirement to probe without platform
data or device tree? I'm just merging in some changes to add device tree
support, and it would simplify things a bit if I can drop this patch.
