Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaHTUwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:52:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:13341 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaHTUwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:52:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,904,1400050800"; 
   d="scan'208";a="590977216"
Message-ID: <53F509AF.9010707@intel.com>
Date: Wed, 20 Aug 2014 13:48:47 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-firmware@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Automatically pull missing FW files
References: <20140820182145.15596.86122.stgit@tstruk-mobl1>	 <1408559681.11365.1.camel@shinybook.infradead.org>	 <53F4F533.5010308@intel.com> <1408567140.9484.0.camel@infradead.org>
In-Reply-To: <1408567140.9484.0.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 01:39 PM, David Woodhouse wrote:
> On Wed, 2014-08-20 at 12:21 -0700, Tadeusz Struk wrote:
>> Hi David,
>> On 08/20/2014 11:34 AM, David Woodhouse wrote:
>>> I'm not sure I understand. Precisely what fails?
>>
>> I clone a subsystem, configure it to use
>> CONFIG_EXTRA_FIRMWARE="qat_895xcc.bin", type make && make install and get:
>>
>> MK_FW   firmware/qat_895xxc.bin.gen.S
>> make[1]: *** No rule to make target `firmware/qat_895xxc.bin', needed by
>> `firmware/qat_895xxc.bin.gen.o'.  Stop.
> 
> Can't you already just use CONFIG_EXTRA_FIRMWARE_DIR ? 


What for? The point is that you don't have the FW binary file and you
have to download it, which can happen automatically and this is what
this patch does. The director where it will be stored doesn't really
matter here.

> 
>> Yes, if you use udev helper. When you want to compile in the blobs to
>> your kernel it is needed in build time, right?
> 
> Yes. But seriously: don't do that. Let firmware get loaded from
> userspace the normal way. Don't build kernel images that you can't distribute
> because they include non-GPL parts.
> 

