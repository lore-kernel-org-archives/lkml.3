Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbaGYTJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:09:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40852 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaGYTJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:09:10 -0400
Message-ID: <53D2AB54.5030809@codeaurora.org>
Date: Fri, 25 Jul 2014 12:09:08 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/9] drivers: base: add new class "cpu" to group cpu
 devices
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-2-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1406306692-7135-2-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/14 09:44, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> This patch creates a new class called "cpu" and assigns it to all the
> cpu devices. This helps in grouping all the cpu devices and associated
> child devices under the same class.
>
> This patch also:
> 1. modifies the get_parent_device to return the legacy path
>    (/sys/devices/system/cpu/..) for the cpu class devices to support
>    existing sysfs ABI
> 2. avoids creating link in the class directory pointing to the device as
>    there would be per-cpu instance of these devices with the same name
> 3. makes sure subsystem symlink continues pointing to cpu bus instead of
>    cpu class for cpu devices
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Why can't we make a 'cache' bus that the cache devices hang off of? It
doesn't make sense to me why we would want to have cache devices living
on the cpu bus.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

