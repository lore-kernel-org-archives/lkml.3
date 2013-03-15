Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3COVZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:25:01 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:35945 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3COVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:24:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130315203010.GA25081@kroah.com>
References: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca> <20130315203010.GA25081@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 15 Mar 2013 21:24:38 +0000
X-Google-Sender-Auth: nz0tXpbHCT5sdeqY9o5NujWscE4
Message-ID: <CACxGe6twB3fSkQ97Jq-+zSn7wen9axS=5fB4uSs08etfREJaPQ@mail.gmail.com>
Subject: Re: [PATCH] tty/serial: Fix uninitialized variable warning
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 8:30 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 04, 2013 at 09:35:07AM +0800, Grant Likely wrote:
>> drivers/tty/serial/8250/8250.c: In function 'serial_unlink_irq_chain':
>> drivers/tty/serial/8250/8250.c:1676:19: warning: 'i' may be used uninitialized in this function
>>
>> There isn't an actual bug here since the function tests the condition
>> that would cause i to be uninitialized before dereferencing i. However,
>> at least some versions of GCC complain as shown above. (in my case,
>> powerpc gcc 2.5.2). Initializing i to NULL makes it clear to GCC and the
>> casual code reviewer that i will not be dereferenced to a random
>> address.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>> Greg, some may argue that this is a tool problem, not a kernel problem,
>> but it is useful to me. If anyone objects I'm not going to spend any
>> time championing for this patch.
>
> Upgrade your tools to ones that work properly :)

FWIW, it's still a toolchain that a lot of people use for embedded
powerpc development.

g.
