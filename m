Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaKDXSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:18:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50959 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKDXSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:18:49 -0500
Message-ID: <54595ED7.2090406@codeaurora.org>
Date: Tue, 04 Nov 2014 17:18:47 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <54595416.1020205@codeaurora.org> <54595590.7080603@codeaurora.org> <3210901.7DuAVnBdHS@vostro.rjw.lan> <545959A8.7010305@codeaurora.org>
In-Reply-To: <545959A8.7010305@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 04:56 PM, Timur Tabi wrote:
>
>  >  I'm
>> not sure how much of that code can be shared between DT and ACPI ATM, but
>> it looks like at least some of it can be shared.
>
> So ACPI does not support the concept if variable length properties?

Ah, I see that it does:

int acpi_dev_prop_read_array(struct acpi_device *adev, const char *propname,
			     enum dev_prop_type proptype, void *val,
			     size_t nval)
{
...
	if (!val)
		return obj->package.count;


If I pass NULL for 'val', it returns the number of items.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
