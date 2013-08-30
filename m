Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3H3UkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:40:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3H3UkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:40:08 -0400
Message-ID: <52210314.4080408@zytor.com>
Date: Fri, 30 Aug 2013 13:39:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bob Liu <lliubbo@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hpa@linux.intel.com, yinghai@kernel.org, jacob.shin@amd.com,
        konrad.wilk@oracle.com, linux-mm@kvack.org,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] x86: e820: fix memmap kernel boot parameter
References: <1377841673-17361-1-git-send-email-bob.liu@oracle.com>
In-Reply-To: <1377841673-17361-1-git-send-email-bob.liu@oracle.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 10:47 PM, Bob Liu wrote:
> Kernel boot parameter memmap=nn[KMG]$ss[KMG] is used to mark specific memory as
> reserved. Region of memory to be used is from ss to ss+nn.
> 
> But I found the action of this parameter is not as expected.
> I tried on two machines.
> Machine1: bootcmdline in grub.cfg "memmap=800M$0x60bfdfff", but the result of
> "cat /proc/cmdline" changed to "memmap=800M/bin/bashx60bfdfff" after system
> booted.
> 
> Machine2: bootcmdline in grub.cfg "memmap=0x77ffffff$0x880000000", the result of
> "cat /proc/cmdline" changed to "memmap=0x77ffffffx880000000".
> 
> I didn't find the root cause, I think maybe grub reserved "$0" as something
> special.
> Replace '$' with '%' in kernel boot parameter can fix this issue.

NAK for the reasons already discussed.

	-hpa


