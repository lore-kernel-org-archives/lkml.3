Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab3DAWRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:17:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3DAWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:17:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,387,1363158000"; 
   d="scan'208";a="34395467"
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH v3 6/7] USB: EHCI: make ehci-msm a separate driver
References: <Pine.LNX.4.44L0.1303291607090.1467-100000@iolanthe.rowland.org>
	<201303301249.09239.arnd@arndb.de>
Date: Mon, 01 Apr 2013 15:17:50 -0700
In-Reply-To: <201303301249.09239.arnd@arndb.de> (Arnd Bergmann's message of
	"Sat, 30 Mar 2013 12:49:09 +0000")
Message-ID: <8yahajp3ng1.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Friday 29 March 2013, Alan Stern wrote:
>> On Thu, 28 Mar 2013, Arnd Bergmann wrote:
>
>> This patch is good.  However the ehci-msm driver itself is not.  While
>> checking through the code, I was struck by the fact that it never calls
>> usb_add_hcd() or usb_remove_hcd().  Obviously the driver cannot work
>> properly.
>> 
>> In addition, it stores the PHY pointer in a global variable.  
>> (ehci-atmel does much the same thing for its clocks.)  This means the
>> driver cannot be used on a system having more than one EHCI controller.  
>> Maybe this doesn't matter, though.
>> 
>> Maybe somebody would like to fix and test it...
>
> I'm not too surprised. The driver was added the last time that the MSM
> maintainers started a serious attempt to get a lot of their code mainlined,
> a little over two years ago. While there is some activity from Qualcomm
> in specific areas of the code every now and then, they literally have
> thousands of patches on top of the kernel that they use in actual
> products and I would not expect a mainline kernel to actually work on
> any recent Qualcomm hardware.

As far as this patch goes, you can have an
  Acked-by: David Brown <davidb@codeaurora.org>
for it.

I'm hoping things are going to get better as far as people working on
things.  EHCI is definitely an important one to get working (as is SD),
but we've got to get clocks and regulators working first.

David


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
