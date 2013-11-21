Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3KUIVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:21:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44428 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3KUIV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:21:29 -0500
Message-ID: <528DC2AA.4070202@gmail.com>
Date: Thu, 21 Nov 2013 09:22:02 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117160126.GG27323@pd.tnic> <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com> <20131117195358.GO27323@pd.tnic> <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com> <20131117220611.GQ27323@pd.tnic> <528A05D0.30907@gmail.com> <20131118133210.GG24851@pd.tnic> <528B36EA.20301@gmail.com> <20131119101521.GA3515@pd.tnic> <528C84A1.5030707@gmail.com> <20131120111541.GA30147@pd.tnic>
In-Reply-To: <20131120111541.GA30147@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 12:15 PM, Borislav Petkov wrote:
> On Wed, Nov 20, 2013 at 10:45:05AM +0100, Francis Moreau wrote:
>> Unfortunately the bisect session didn't give any positive results: I
>> couldn't be sure if a specific revision was good or bad because the
>> bug wasn't reproductible every time.
>>
>> But I got a different kernel oops on my stripped system that may give
>> us a clue: http://imgur.com/zdCknbY
>>
>> Does this help ?
> 
> Unfortunately, this is the second oops:
> 
[...]
> 
> and judging by the instruction, that's addr in %rdi which we try to read
> and I'd guess %rdi contains garbage after resume.
> 
> IOW, this looks like another corruption that happens when you suspend to
> ram.

Hmm, I think it's more than that because if I'm removing both
rtsx_pci_ms and memstick modules, then suspending and resuming doesn't
oops anymore.

Also I took a look at the changes between v3.11 and v3.12 in this area
and those changes match the issue I'm facing:

$ git log --oneline v3.11..v3.12 -- drivers/mfd/rtsx_pcr.c
09fd867 mfd: rtsx: Copyright modifications
eb891c6 mfd: rtsx: Configure to enter a deeper power-saving mode in S3
7140812 mfd: rtsx: Move some actions from rtsx_pci_init_hw to individual
extra_init_hw
5947c16 mfd: rtsx: Add shutdown callback in rtsx_pci_driver
773ccdf mfd: rtsx: Read vendor setting from config space

I'll try to bisect one more time those changes tonight to see if I can
find out if one of those commits is the culprit.

> 
> I asked you already but you didn't say:
> 
> "Also, you can check for BIOS updates for your machine and if there are,
> check their changelogs whether they fix something suspend-related."
> 

Sorry for not answering the first time, but yes my bios is uptodate.

Thanks.
