Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab3BKTov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:44:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39944 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451Ab3BKTot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:44:49 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130211182826.GE2683@pd.tnic>
References: <20130208202813.62965F25@kernel.stglabs.ibm.com> <20130209094121.GB17728@pd.tnic> <20130209104751.GC17728@pd.tnic> <51192B39.9060501@linux.vnet.ibm.com> <20130211182826.GE2683@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] add helper for highmem checks
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 11 Feb 2013 11:44:12 -0800
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@kernel.org,
        tglx@linutronix.de
Message-ID: <7794bbcd-5d5a-4e81-87fd-68b0aa17a556@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, craptastic.  X used to hash /dev/mem to get a random seed.  It should have stopped that long ago, and used /dev/[u]random.

Borislav Petkov <bp@alien8.de> wrote:

>On Mon, Feb 11, 2013 at 09:32:41AM -0800, Dave Hansen wrote:
>> That's crazy. Didn't expect that at all.
>>
>> I guess X is happier getting an error than getting random pages back.
>
>Yeah, I think this is something special only this window manager wdm
>does. The line below has appeared repeatedly in the logs earlier:
>
>Feb  5 23:02:02 a1 wdm: Cannot read randomFile "/dev/mem", errno = 14
>
>This happens when wdm starts so I'm going to guess it uses it for
>something funny, "randomFile" it calls it??
>
>With the WARN_ON check added and booting 3.8-rc6, it would choke wdm
>somehow and it wouldn't start properly so that even the error out above
>doesn't happen. Oh well ...
>
>> I'm working on a set of patches now that should get it _working_
>> instead of just returning an error.
>
>Yeah, send them on and I'll run them.
>
>Thanks.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
