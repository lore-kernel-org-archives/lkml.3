Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaHOKpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:45:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50019 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaHOKpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:45:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53EDE4B3.6090903@roeck-us.net>
Date: Fri, 15 Aug 2014 03:45:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        clemens@ladisch.de, jdelvare@suse.de, rdunlap@infradead.org,
        bp@suse.de
CC: lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] hwmon, k10temp: Add support for F15h M60h
References: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
In-Reply-To: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 04:15 PM, Aravind Gopalakrishnan wrote:
> This patch adds temperature monitoring support for F15h M60h processor.
>   - Add new pci device id for the relevant processor
>   - The functionality of REG_REPORTED_TEMPERATURE is moved to
>     D0F0xBC_xD820_0CA4 [Reported Temperature Control]
>     - So, use this to get CUR_TEMP value
>     - Since we need an indirect register access, protect this with
>       a mutex lock
>   - Add Kconfig, Doc entries to indicate support for this processor.
>
> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> ---
> Changes in V3:
>   - Move helper function that protects indirect register access locally
>     until a time when others outside k10temp may need it
>

Applied, with a small change: I made the mutex and the new function static.
That can be changed if/when needed, and declaring it static now ensures that
we'll notice it. Likely the "next" user won't use the function anyway, but
that is a problem to sort out after it happens.

Thanks,
Guenter

