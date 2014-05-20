Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaETQ5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:57:20 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40215 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaETQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <aa949b75ae938371ecd3bd5b35577bca.squirrel@www.luminoussheep.net>
References: <42308d5cdecee35097f0ac8ae3a0fbe8.squirrel@www.luminoussheep.net>
	<aa949b75ae938371ecd3bd5b35577bca.squirrel@www.luminoussheep.net>
Date: Tue, 20 May 2014 20:57:18 +0400
Message-ID: <CALYGNiM0hqDmD2wKVu8rA1Y3UUgYQ+Ho2V_HG0wxNgdzDNWdFg@mail.gmail.com>
Subject: Re: General protection fault - bug report 3.12.18
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Martin <martin@luminoussheep.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've looked into second crash. Just because gmail has marked that
email as important for some reason =)

In function tid_fd_revalidate(), in line "file = fcheck_files(files,
fd)" file = is 0x0000000004000000 instead of valid pointer or NULL.
This value has only one non-zero bit, so this looks like memory
curruption.

More likely this is hardware problem. Please check you memory with
memtest86 and/or try to replace it.

On Mon, May 19, 2014 at 1:46 AM, Martin <martin@luminoussheep.net> wrote:
>> Hi,
>>
>> I'm having regular issues with crashes, this time I was only browsing the
>> web.
>> Please could you let me know how best to report this if this isn't the
>> right way.
>
> This is an oops this time not sure if this is related.
>
> Thanks,
> M
