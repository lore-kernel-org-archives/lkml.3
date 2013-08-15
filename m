Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3HOMhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:37:09 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47737 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3HOMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:37:07 -0400
Message-ID: <520CCB70.8090908@gmail.com>
Date: Thu, 15 Aug 2013 07:37:04 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1376564133-11286-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 05:55 AM, Dong Aisheng wrote:
> We meet some boards having a lot of pin conflicts between different devices,
> only one of them can be enabled to run at one time.
> 
> e.g. imx6q sabreauto board, i2c, spi, weim, flexcan, uart and etc involved
> with pin conflict.
> 
> Instead of changing dts manually or adding a lot dts files according to
> different device availability, we provide feature to dynamically update the
> device node status via command line, then those devices involved with
> pin conflict can be enabled or disabled dynamically.
> 
> It's conveniently to use and can save a lot dts board files, also can
> permenantly fix the pin conflicts issue.

This doesn't scale either with updating of lots devices or when the next
person comes along and wants to edit another property.

This is something u-boot is perfectly capable of handling and updating
status is something lots of boards already do.

Rob

> 
> The patch series is based on v3.11-rc5.
> 
> Dong Aisheng (3):
>   of: add device node status update APIs
>   of: add update device node status via cmdline feature
>   of: add node status update via name format with cmdline
> 
>  Documentation/kernel-parameters.txt |   10 +++
>  drivers/of/base.c                   |  107 +++++++++++++++++++++++++++++++++
>  drivers/of/fdt.c                    |  111 +++++++++++++++++++++++++++++++++++
>  include/linux/of.h                  |   13 ++++
>  4 files changed, 241 insertions(+), 0 deletions(-)
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

