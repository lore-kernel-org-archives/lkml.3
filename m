Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab3DAVrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:47:45 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:37122 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab3DAVrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:47:42 -0400
Subject: Re: [PATCH 1/2] Allow constructor name selection by architecture.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "George G. Davis" <gdavis@mvista.com>
In-Reply-To: <20120606101253.GM8262@n2100.arm.linux.org.uk>
Date: Mon, 1 Apr 2013 17:47:38 -0400
Cc: Davis George <gdavis@mvista.com>,
        Vincent Sanders <vincent.sanders@collabora.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Vincent Sanders <vince@collabora.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <87F2CC87-0FAF-49CB-AE70-423FB063A0E5@mvista.com>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk> <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk> <20120528203005.GA20560@merkur.ravnborg.org> <20120529090614.GD12217@n2100.arm.linux.org.uk> <20120606101253.GM8262@n2100.arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 6, 2012, at 6:12 AM, Russell King - ARM Linux wrote:
> On Tue, May 29, 2012 at 10:06:14AM +0100, Russell King - ARM Linux wrote:
>> On Mon, May 28, 2012 at 10:30:05PM +0200, Sam Ravnborg wrote:
>>> On Mon, May 28, 2012 at 07:33:37PM +0100, Vincent Sanders wrote:
>>>> From: Vincent Sanders <vince@collabora.co.uk>
>>>> 
>>>> The constructor symbol name is different between platforms. Allow this
>>>> to be selected by configuration and set suitable default values.
>>>> 
>>>> Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
>>>> ---
>>>> include/asm-generic/vmlinux.lds.h |    6 +++---
>>>> init/Kconfig                      |    6 ++++++
>>>> kernel/module.c                   |    2 +-
>>>> 3 files changed, 10 insertions(+), 4 deletions(-)
>>>> 
>>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>>>> index 8aeadf6..fd34808 100644
>>>> --- a/include/asm-generic/vmlinux.lds.h
>>>> +++ b/include/asm-generic/vmlinux.lds.h
>>>> @@ -471,9 +471,9 @@
>>>> 	}
>>>> 
>>>> #ifdef CONFIG_CONSTRUCTORS
>>>> -#define KERNEL_CTORS()	. = ALIGN(8);			   \
>>>> -			VMLINUX_SYMBOL(__ctors_start) = .; \
>>>> -			*(.ctors)			   \
>>>> +#define KERNEL_CTORS()	. = ALIGN(8);					\
>>>> +			VMLINUX_SYMBOL(__ctors_start) = .;		\
>>>> +			*(CONFIG_CONSTRUCTORS_NAME)			\
>>>> 			VMLINUX_SYMBOL(__ctors_end) = .;
>>> 
>>> What is wrong with adding both "standard" names for ctors uncnditionally?
>>> Like this:
>>>> 			*(.ctors)			   \
>>>> +			*(.init_array)			   \
>> 
>> That doesn't get rid of CONFIG_CONSTRUCTORS_NAME, because it's needed
>> in the module code.  Do you have a suggestion to solve that as well?
> 
> Ping.

Pinging this back to life.  I'd like to see GCOV for ARM eABI finally make it upstream.
So, any objections to this?  Should it be resubmitted?

TIA!

--
Regards,
George