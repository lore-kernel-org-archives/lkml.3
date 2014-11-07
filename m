Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaKGVCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:02:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62183 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKGVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:02:19 -0500
Date: Fri, 7 Nov 2014 22:00:06 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 20/48] mfd: rn5t618: Register power-off handler with
 kernel power-off handler
Message-ID: <20141107210006.GA22111@gmail.com>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <1415292213-28652-21-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415292213-28652-21-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:43:04AM -0800, Guenter Roeck wrote:
> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Cc: Beniamino Galvani <b.galvani@gmail.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v5:
> - Rebase to v3.18-rc3
> v4:
> - Do not use notifiers but internal functions and data structures to manage
>   the list of power-off handlers. Drop unused parameters from callbacks, and
>   make the power-off function type void
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - New patch
> 
>  drivers/mfd/rn5t618.c       | 28 ++++++++++++----------------
>  include/linux/mfd/rn5t618.h |  2 ++
>  2 files changed, 14 insertions(+), 16 deletions(-)

Tested-by: Beniamino Galvani <b.galvani@gmail.com>
