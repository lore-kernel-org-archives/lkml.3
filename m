Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaCMXIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:08:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27974 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaCMXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:07:59 -0400
Message-ID: <53223A4A.7070408@oracle.com>
Date: Thu, 13 Mar 2014 19:07:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>	<5321CBDA.1060705@oracle.com>	<CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>	<53222F1A.8090205@oracle.com> <CA+55aFxi5VQFu6_MVaVWhwj+bo-orQUmsKRakr_1Txfu1bEcpg@mail.gmail.com>
In-Reply-To: <CA+55aFxi5VQFu6_MVaVWhwj+bo-orQUmsKRakr_1Txfu1bEcpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 06:59 PM, Linus Torvalds wrote:
> On Thu, Mar 13, 2014 at 3:20 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> I'll fix it up and re-send this patch.
>
> The problem (as you will find out) is that "addr2line" doesn't take
> symbolic names.
>
> So either addr2line needs to be improved (which really would be a good
> idea regardless), or your script needs to use "nm" or "gdb" or
> something to first translate the symbol+off into a hex number (which
> will not match the kernel-provided hex number when base randomization
> is in effect, but it will match the pre-randomized data in the vmlinux
> file, so then addr2line would work).

I figured that I'll just read it from System.map (and do the math when
adding the offset). That should work, right?


Thanks,
Sasha

