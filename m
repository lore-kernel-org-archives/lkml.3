Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaAZUaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:30:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38573 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaAZUaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:30:18 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140126202749.GA10254@gmail.com>
References: <1390611565-18709-1-git-send-email-yinghai@kernel.org> <20140125080232.GA20935@gmail.com> <52E4FE02.2020004@redhat.com> <20140126133203.GA1370@gmail.com> <52E55FB1.4060404@redhat.com> <20140126202140.GB8224@gmail.com> <4f0b30ff-6adb-46f5-bad4-ed42956e2a39@email.android.com> <20140126202749.GA10254@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v2] x86: allocate cpumask during check irq vectors
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 26 Jan 2014 12:29:49 -0800
To: Ingo Molnar <mingo@kernel.org>
CC: Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Message-ID: <eb93bdba-d16d-4a85-ae40-f265b1db5ed4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I strongly disagree with putting variables in file scope when function scope will do, but I do like to see static variables before automatics.  Anyway, this is bikeshedding.

Ingo Molnar <mingo@kernel.org> wrote:
>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> s/global/static/, with a big loud comment why it is okay.
>
>It would be a global no matter which form we use, but for 
>maintainability reasons I generally prefer a static put right before 
>the function that uses it:
>
>	static cpumask_t mask;
>
>	static func(...)
>	{
>	}
>
>That makes it really apparent that it's a global - statics are easily 
>missed when hiding amongst local variables.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
