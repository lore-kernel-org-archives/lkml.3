Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaDOC3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:29:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34942 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDOC3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:29:07 -0400
Message-ID: <534C995F.9040101@oracle.com>
Date: Mon, 14 Apr 2014 22:28:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Move instruction decoder data into header
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-2-git-send-email-sasha.levin@oracle.com> <534C8E2D.9020506@hitachi.com>
In-Reply-To: <534C8E2D.9020506@hitachi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 09:41 PM, Masami Hiramatsu wrote:
> (2014/04/15 2:44), Sasha Levin wrote:
>> > Right now we generate data for the instruction decoder and place it
>> > as a code file which gets #included directly (yuck).
>> > 
>> > Instead, make it a header which will also be usable by other code
>> > that wants to use the data in there.
> Hmm, making the generated data into a header file may clone
> the data table instances for each object file. Since the inat
> table is not so small, I think we'd better just export the tables.

The tables are defined as static, so the compiler drops them
once it detects they are not used.

I feel it would be easier to let the compiler do it's job rather
than do optimizations we don't need to do and which will complicate
the code quite a bit.


Thanks,
Sasha
