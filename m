Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaDUG2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:28:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:43704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaDUG2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:28:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,895,1389772800"; 
   d="scan'208";a="496579487"
Message-ID: <5354BA59.2000008@linux.intel.com>
Date: Mon, 21 Apr 2014 14:27:37 +0800
From: "Jin, Yao" <yao.jin@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Adam Williamson <awilliam@redhat.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>	 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>	 <5353A1F6.60602@linux.intel.com> <5353B8A4.1080900@linux.intel.com> <1398007690.2674.0.camel@adam.happyassassin.net>
In-Reply-To: <1398007690.2674.0.camel@adam.happyassassin.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/4/20 23:28, Adam Williamson wrote:
> On Sun, 2014-04-20 at 20:08 +0800, Jin, Yao wrote:
>> For the issue that touch screen doesn't work, could you check power
>> state of LPSS devices? For example:
>>
>> cd /sys/bus/acpi/devices
>> grep -H . */power_state
>>
>> If they are D3cold, it should be the reason why touch screen doesn't
>> work. That's another issue, unrelated to this gpio patch.
> 
> The touch screen worked fine with kernel 3.14, and Benjamin looked at
> debug output from the attempt to load the touchscreen driver when
> diagnosing the problem, he's not just guessing. I am building a kernel
> without your patch to confirm that fixes it.
> 

I tried the clean kernel 3.14 with the boot option "nomodeset text" on
Dell Venue 11 Pro (If without "nomodeset",my ubuntu is being "black
screen", but that should be another i915 issue).

After system starup, I executed the "startx" to launch the xwindow. In
xwindow, the touchscreen work.

I tried the kernel 3.14 again with my gpio patch applied, the result was
the same, the touchscreen work.

I also check the DSDT table of Dell Venue 11 Pro by searching the
keyword "Interrupt", I can't find any clue for the irq conflict.

I'm sorry I don't have a Dell Venue 8 for testing, but I guess it's
similar to Dell Venue 11 Pro.
