Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaDQPdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:33:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49535 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDQPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:33:29 -0400
Message-ID: <534FF43A.109@oracle.com>
Date: Thu, 17 Apr 2014 11:33:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534E18B1.4020802@hitachi.com>
In-Reply-To: <534E18B1.4020802@hitachi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 01:44 AM, Masami Hiramatsu wrote:
> Same thing can be done in awk part and insn.c, and we can encode it by
> 
> #define INAT_MAKE_MEMSZ(size) (size << INAT_MEMSZ_OFFS)
> 
> And decode it by
> 
> insn->memsz_bytes = 1 << ((attr & INAT_MEMSZ_MASK) >> INAT_MEMSZ_OFFS)
> 
> Thus, we only need 3 bits to represent 1, 2, 4, 8, 16 and 32. :)

We'll need 4 so that we could do 64 too :)

btw, why aren't we using regular bitfields? this manual encoding
thingie seems to be a bit confusing (try figuring out how many
bits are left...).


Thanks,
Sasha
