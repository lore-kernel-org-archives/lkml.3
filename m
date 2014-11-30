Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaK3Dr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 22:47:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36121 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaK3Drz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 22:47:55 -0500
Message-ID: <547A935F.6070601@oracle.com>
Date: Sat, 29 Nov 2014 22:47:43 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/2] compiler: use compiler to detect integer overflows
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>	<CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>	<54768059.1080406@oracle.com>	<CA+55aFxx+Ye+v6bkK0TwzkAHxSEUc7e-EAW-1JD8mySE2nVq2w@mail.gmail.com>	<5479E11C.8080701@oracle.com> <CA+55aFzTc=vXUQ8ZrWWVj4DNmrZOEr3bcYpiGt6+KEVWPW-x2g@mail.gmail.com>
In-Reply-To: <CA+55aFzTc=vXUQ8ZrWWVj4DNmrZOEr3bcYpiGt6+KEVWPW-x2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2014 01:08 PM, Linus Torvalds wrote:
> On Sat, Nov 29, 2014 at 7:07 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > Since we can't just change those to unsigned
> Sure we can. Just cast them. A signed start/len is bogus crap, it's a
> random wrong type.

But this is going on everywhere in fs/! It uses loff_t for pretty much anything,
even stuff which are obviously are unsigned (inode.i_size for example). Do you
think it's worth the effort to switch is all to unsigned?


Thanks,
Sasha
