Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaHTTZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:25:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:37795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaHTTZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,904,1400050800"; 
   d="scan'208";a="590942566"
Message-ID: <53F4F533.5010308@intel.com>
Date: Wed, 20 Aug 2014 12:21:23 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-firmware@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Automatically pull missing FW files
References: <20140820182145.15596.86122.stgit@tstruk-mobl1> <1408559681.11365.1.camel@shinybook.infradead.org>
In-Reply-To: <1408559681.11365.1.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 08/20/2014 11:34 AM, David Woodhouse wrote:
> I'm not sure I understand. Precisely what fails?

I clone a subsystem, configure it to use
CONFIG_EXTRA_FIRMWARE="qat_895xcc.bin", type make && make install and get:

MK_FW   firmware/qat_895xxc.bin.gen.S
make[1]: *** No rule to make target `firmware/qat_895xxc.bin', needed by
`firmware/qat_895xxc.bin.gen.o'.  Stop.

I thought it might be useful if it would pull whatever FW it needs and
not just give up. It also might be useful if one wants to "refresh" the
FW binaries. In this case one can do rm firmware/*.[bin|ihex] && make &&
make install

> 
> I don't like this patch very much. We should be removing the legacy
> firmware/ directory entirely, not patching it up.
> 
> Userspace is responsible for providing the firmware, and it should
> generally come from an entirely separate checkout of the linux-firmware
> repository.

Yes, if you use udev helper. When you want to compile in the blobs to
your kernel it is needed in build time, right?
In both cases you need the binary anyway so you can copy it manually
from linux-firmware or use this nice feature to do it for you.
If you want to remove firmware/ directory entirely then this makefile
will be gone as well so what's the problem?

