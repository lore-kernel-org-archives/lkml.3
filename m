Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbaD3FT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:19:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45692 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaD3FTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:19:53 -0400
Message-ID: <536087D5.1040409@zytor.com>
Date: Tue, 29 Apr 2014 22:19:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: behanw@converseincode.com, viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] mbcache: LLVMLinux: Remove double calculation from mbcache
References: <1398820239-1890-1-git-send-email-behanw@converseincode.com> <a54957c1-4825-4265-8126-4565168fe8c6@email.android.com>
In-Reply-To: <a54957c1-4825-4265-8126-4565168fe8c6@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:13 PM, H. Peter Anvin wrote:
> I suspect this will generate FP instructions on x86 which will corrupt user space state.  This is thus a critical bug!!

It looks like at least x86-64 gcc does the evaluation at compile time
and there aren't any fp instructions left in the code. However, it
should still be fixed.

	-hpa

