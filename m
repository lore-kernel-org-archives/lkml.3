Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaEURfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:35:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39653 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaEURfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:35:17 -0400
Message-ID: <537CE3C2.8030601@zytor.com>
Date: Wed, 21 May 2014 10:34:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: Bisected 3.9 regression: Corrupted low memory (x86, mm: Move
 reserving low memory later in initialization)
References: <CACna6rzTUnxHJX8MmDAbmj5SsL_VscfdV5oj735zMtLY5k8JCA@mail.gmail.com> <CACna6rxb2+xBFRt-g7ttkSB++-WtVEMycC7G=wf1ircKPW12ZQ@mail.gmail.com>
In-Reply-To: <CACna6rxb2+xBFRt-g7ttkSB++-WtVEMycC7G=wf1ircKPW12ZQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 06:31 AM, Rafał Miłecki wrote:
> On 16 May 2014 07:29, Rafał Miłecki <zajec5@gmail.com> wrote:
>> Sorry for the late report, this bug appears on my old notebook I don't
>> commonly use. Anyway, I've noticed following problem when using
>> 3.15-rc1:
>>
>> Corrupted low memory at ffff88000000be98 (be98 phys) = b02a000400000000
> 
> Ping?
> 

It's not a regression, but rather a progression: the checker now does
what it claims to do, which is to check for low memory corruption.

However, the checker is also rather useless as anything other than a
diagnostic tool.  It tells you that your BIOS is corrupting memory, and
the solution to that is to reserve the memory, which we already do.

All the checker tells us is that on your system, yes, we really do need
to reserve the memory.

	-hpa

