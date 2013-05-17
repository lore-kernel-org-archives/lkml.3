Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3EQSHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:07:36 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:64057 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3EQSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:07:35 -0400
MIME-Version: 1.0
X-Originating-IP: [84.109.219.89]
In-Reply-To: <1368609586-20905-1-git-send-email-leon@leon.nu>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
From: Leon Romanovsky <leon@leon.nu>
Date: Fri, 17 May 2013 21:07:14 +0300
Message-ID: <CALq1K=KP4pADX89QJ3MJzaC+uTeEVOy7FUNikEnYddb0u-rihw@mail.gmail.com>
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Leon Romanovsky <leon@leon.nu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, May 15, 2013 at 12:19 PM, Leon Romanovsky <leon@leon.nu> wrote:
> There is no need to call kfree while using devm_kzalloc,
> remove it from *_device_init function.
>
> Signed-off-by: Leon Romanovsky <leon@leon.nu>
> ---
>  drivers/mfd/tps65912-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

To be honest the whole tps65912 looks strange to me.
For example,  kfree(tps65912) calls all over the code.

tps65912_i2c_probe allocates tps65912 struct, but tps65912_device_exit
releases it.


--
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
