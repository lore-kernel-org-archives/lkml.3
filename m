Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaKTMNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:13:36 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:32909 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKTMNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:13:35 -0500
Message-ID: <546DDAE9.7010602@collabora.co.uk>
Date: Thu, 20 Nov 2014 13:13:29 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device interface
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk> <1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk> <20141118141827.GB24004@x1> <546DD00E.4000704@collabora.co.uk> <20141120115817.GC13269@x1>
In-Reply-To: <20141120115817.GC13269@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 11/20/2014 12:58 PM, Lee Jones wrote:
>> the printk.h header? to use the pr_* functions but I'll make sure that only
>> the needed headers are included.
> 
> Right, I think don't think you should be using those on a platform device.
>

Yes, I'll use dev_err() instead.
 
>> I prefer macros if possible since they cost nothing and give you an indirection
>> level if you want to change it later. Any reason to not use a define directive?
> 
> Exactly as you said, they add a layer of (pointless)
> indirection/complexity.  You only use this name once, just change it
> where you use it if you wish to (but probably never will) adapt the
> name. 
>

Fair enough, I'll remove it.
 
> 
> I know how the device driver model works.  I'm asking where the
> 'device' is registered from, not the 'driver' i.e. platform data, DT,
> ACPI?
> 

Right, sorry for misunderstanding your question and the silly comment then.

$Subject adds a "cros-ec-dev" mfd cell to the cros ec mfd driver.
So the device is registered from DT when the cros ec device node is
matched (e.g: "google,cros-ec-spi" or "google,cros-ec-i2c") and the
cros ec mfd driver probe function calls mfd_add_devices().

Best regards,
Javier
