Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3HLOwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab3HLOw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:52:27 -0400
Message-ID: <1376319113.32237.23.camel@t520.redhat.com>
Subject: Re: [PATCH 15/16] Add EFI stub for ARM
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Mon, 12 Aug 2013 10:51:53 -0400
In-Reply-To: <1376090777-20090-16-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-16-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> +static int relocate_kernel(efi_system_table_t *sys_table,
> +                          unsigned long *zimage_addr,
> +                          unsigned long zimage_size,
> +                          unsigned long min_addr, unsigned long max_addr)
> +{
> +       /* Get current address of kernel. */
> +       unsigned long cur_zimage_addr = *zimage_addr;
> +       unsigned long new_addr = 0;
> +
> +       efi_status_t status;
> +
> +       if (!zimage_addr || !zimage_size)
> +               return EFI_INVALID_PARAMETER;
> +

This parameter check is too late. You already used zimage_addr to
initialize cur_zimage_addr.

--Mark


