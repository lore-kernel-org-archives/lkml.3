Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaFBShz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:37:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:30473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaFBShy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,958,1392192000"; 
   d="scan'208";a="541371444"
Message-ID: <538CC3E4.2080700@linux.intel.com>
Date: Mon, 02 Jun 2014 11:35:16 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Subject: Re: [PATCH 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
References: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com> <20140530084822.GC1645@lahna.fi.intel.com>
In-Reply-To: <20140530084822.GC1645@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-30 01:48 AM, Mika Westerberg wrote:
> On Tue, May 27, 2014 at 12:26:44PM -0700, eric.ernst@linux.intel.com wrote:
>> From: Eric Ernst <eric.ernst@linux.intel.com>
>>
>> For Baytrail, you should never set a GPIO set to direct_irq
>> to output mode.  When direct_irq_en is set for a GPIO, it is
>> tied directly to an APIC internally, and making the pad output
>> does not make any sense. Assert a WARN() in the event this happens.
> Can't we just clear that flag when the GPIO is requested? Or is this
> something which can't be done at this point?
The IRQ setting for that register (the IRQ wiring via direct_irq_en) 
should be set statically on boot, and should not be changed, let alone 
allowing for multiple changes during runtime.

Eric
