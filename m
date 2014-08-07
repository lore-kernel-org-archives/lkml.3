Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbaHGMU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:20:59 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:3132 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754471AbaHGMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:20:58 -0400
Message-ID: <53E36F25.4030501@itdev.co.uk>
Date: Thu, 07 Aug 2014 13:20:53 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>, Yufeng Shen <miletus@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: atmel_mxt_ts - Get IRQ edge/level flags on
 DT booting
References: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/14 01:48, Javier Martinez Canillas wrote:
> The Atmel maXTouch driver assumed that the IRQ type flags will
> always be passed using platform data but this is not true when
> booting using Device Trees. In these setups the interrupt type
> was ignored by the driver when requesting an IRQ.
> 
> This means that it will fail if a machine specified other type
> than IRQ_TYPE_NONE. The right approach is to get the IRQ flags
> that was parsed by OF from the "interrupt" Device Tree propery.

I do not believe you are correct about this. There is a bit of code here:
http://lxr.free-electrons.com/source/kernel/irq/manage.c?v=3.16#L1172
which means that in the device tree case, if we call request_threaded_irq()
with no trigger bits set, it will trust whatever it already there. I did
test this back in July and it appeared to work correctly.

Have you tested this change is actually necessary?
