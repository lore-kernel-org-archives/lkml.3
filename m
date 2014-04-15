Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbaDODLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:11:02 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34643 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaDODLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:11:00 -0400
Message-ID: <534CA33B.3040203@hitachi.com>
Date: Tue, 15 Apr 2014 12:10:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 2/4] x86: Move instruction decoder data into header
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-2-git-send-email-sasha.levin@oracle.com> <534C8E2D.9020506@hitachi.com> <534C995F.9040101@oracle.com>
In-Reply-To: <534C995F.9040101@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 11:28), Sasha Levin wrote:
> On 04/14/2014 09:41 PM, Masami Hiramatsu wrote:
>> (2014/04/15 2:44), Sasha Levin wrote:
>>>> Right now we generate data for the instruction decoder and place it
>>>> as a code file which gets #included directly (yuck).
>>>>
>>>> Instead, make it a header which will also be usable by other code
>>>> that wants to use the data in there.
>> Hmm, making the generated data into a header file may clone
>> the data table instances for each object file. Since the inat
>> table is not so small, I think we'd better just export the tables.
> 
> The tables are defined as static, so the compiler drops them
> once it detects they are not used.

No, I meant that if the table is used in the different object files,
will the copies of the tables be compiled in several different
instances?

And I can't see the part which makes the tables static in this patch...

> I feel it would be easier to let the compiler do it's job rather
> than do optimizations we don't need to do and which will complicate
> the code quite a bit.

I haven't tend to optimize it, but just encapsulate it, to hide from other parts.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


