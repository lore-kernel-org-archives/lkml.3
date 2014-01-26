Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaAZU1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:27:54 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:36987 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:27:53 -0500
Date: Sun, 26 Jan 2014 21:27:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86: allocate cpumask during check irq vectors
Message-ID: <20140126202749.GA10254@gmail.com>
References: <1390611565-18709-1-git-send-email-yinghai@kernel.org>
 <20140125080232.GA20935@gmail.com>
 <52E4FE02.2020004@redhat.com>
 <20140126133203.GA1370@gmail.com>
 <52E55FB1.4060404@redhat.com>
 <20140126202140.GB8224@gmail.com>
 <4f0b30ff-6adb-46f5-bad4-ed42956e2a39@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f0b30ff-6adb-46f5-bad4-ed42956e2a39@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> s/global/static/, with a big loud comment why it is okay.

It would be a global no matter which form we use, but for 
maintainability reasons I generally prefer a static put right before 
the function that uses it:

	static cpumask_t mask;

	static func(...)
	{
	}

That makes it really apparent that it's a global - statics are easily 
missed when hiding amongst local variables.

Thanks,

	Ingo
