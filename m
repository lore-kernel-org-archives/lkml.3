Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaA3TZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:25:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaA3TZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:25:10 -0500
Message-ID: <52EAA714.3080809@infradead.org>
Date: Thu, 30 Jan 2014 11:25:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andiry Xu <andiry@gmail.com>, linux-kernel@vger.kernel.org
CC: Andiry Xu <andiry.xu@gmail.com>, Linux MM <linux-mm@kvack.org>
Subject: Re: [BUG] Description for memmap in kernel-parameters.txt is wrong
References: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com>
In-Reply-To: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding linux-mm mailing list]

On 01/30/2014 08:52 AM, Andiry Xu wrote:
> Hi,
> 
> In kernel-parameters.txt, there is following description:
> 
> memmap=nn[KMG]$ss[KMG]
>                         [KNL,ACPI] Mark specific memory as reserved.
>                         Region of memory to be used, from ss to ss+nn.

Should be:
                          Region of memory to be reserved, from ss to ss+nn.

but that doesn't help with the problem that you describe, does it?


> Unfortunately this is incorrect. The meaning of nn and ss is reversed.
> For example:
> 
> Command                  Expected                 Result
> memmap 2G$6G        6G - 8G reserved      2G - 8G reserved
> memmap 6G$2G        2G - 8G reserved      6G - 8G reserved

Are you testing on x86?
The code in arch/x86/kernel/e820.c always parses mem_size followed by start address.
I don't (yet) see where it goes wrong...


> Test kernel version 3.13, but I believe the issue has been there long ago.
> 
> I'm not sure whether the description or implementation should be
> fixed, but apparently they do not match.

I prefer to change the documentation and leave the implementation as is.


-- 
~Randy
