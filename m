Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaHKBls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:41:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:16740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaHKBlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,838,1400050800"; 
   d="scan'208";a="586228122"
Message-ID: <53E81EBF.5020905@intel.com>
Date: Mon, 11 Aug 2014 09:39:11 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] i2c for 3.17
References: <20140809135557.GA4837@katana> <CA+55aFy0UVY=60pCr85AvhedfO-MEoD-iMGdWmBYt8fKgF7kWA@mail.gmail.com>
In-Reply-To: <CA+55aFy0UVY=60pCr85AvhedfO-MEoD-iMGdWmBYt8fKgF7kWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月10日 01:34, Linus Torvalds wrote:
> On Sat, Aug 9, 2014 at 6:56 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>>
>> here is the pull request for 3.17 for the I2C subsystem. Highlights:
> 
> Lowlight: selecting ACPI support (which used to be the default if ACPI
> was enabled) now forces i2c to be built-in.
> 
> I've pulled this, but it's broken. You need to fix it someway.
> 
> The reason for this is
> 
>   config I2C
>          tristate "I2C support"
>   ...
>   config I2C_ACPI
>          bool "I2C ACPI support"
>          select I2C
>          depends on ACPI
>    ...
> 
> where if I2C_APCI is on (y), then that "select I2C" will cause I2C to
> be upgraded to 'y' as well.
> 
> This seems to be intentional, judging by the commit message, but it's
> wrong. Distributions etc generally compile i2c as a module, and you've
> now broken that.
> 
> This is a regression. Change the "select I2C" to a "depends on I2C",
> and test the end result. Don't force people to build things into the
> kernel.

Hi Linus:
	Sorry about this, I will create a fix patch soon. Thanks.

> 
>                  Linus
> 


-- 
Best regards
Tianyu Lan
