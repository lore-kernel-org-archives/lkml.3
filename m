Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaKDWjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:39:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47894 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:39:14 -0500
Message-ID: <54595590.7080603@codeaurora.org>
Date: Tue, 04 Nov 2014 16:39:12 -0600
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
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <4832015.R1NooRni06@vostro.rjw.lan> <54594A4B.1030207@codeaurora.org> <4886671.cQ44SiRoEW@vostro.rjw.lan> <54595416.1020205@codeaurora.org>
In-Reply-To: <54595416.1020205@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 04:32 PM, Timur Tabi wrote:
>
> There are lots of situations where you don't know the size of the
> property in advance (e.g. strings), and drivers use of_find_property()
> or of_get_property() to pre-allocate a buffer or to verify that the
> property is correctly formed in the device tree.

To follow-up, I have this problem right now with pinctrl_dt_to_map(). 
The pinctrl-%d property in the device tree is an array of phandles.  The 
array can be any size, and pinctrl_dt_to_map() queries the size of the 
property to determine how many phandles there are.  It iterates over all 
of them.  How do I support that with device_property_read_u32_array()? 
That function expects to be told how many phandles there are, and it 
doesn't even tell me if there are more or fewer than the number I've given.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
