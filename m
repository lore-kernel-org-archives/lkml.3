Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaEWN7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:59:16 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37099 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaEWN7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:59:15 -0400
Message-ID: <537F53BE.8030105@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 19:27:18 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: mikey@neuling.org, avagin@openvz.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com> <537252C0.6090005@redhat.com> <53730326.6000400@linux.vnet.ibm.com> <53735044.5030008@redhat.com> <537479FD.2010200@linux.vnet.ibm.com> <5374AE24.1030302@redhat.com> <5379EF0E.6090504@linux.vnet.ibm.com> <537A1889.8030801@redhat.com> <537B0EE0.4080406@linux.vnet.ibm.com> <537B2F5E.4040102@redhat.com> <537D8641.8090600@linux.vnet.ibm.com>
In-Reply-To: <537D8641.8090600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052313-9574-0000-0000-00000DC45E73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 10:38 AM, Anshuman Khandual wrote:
> I agree.
> 
>> > 
>> > Maybe we should leave this for another day, and have tm_spr_active
>> > return 0 instead of -ENODEV when the machine doesn't have the hardware,
>> > or not install that hook at all.  Seems like the effect will be the same,
>> > as the note isn't output if ->get fails.

> Agree. Active hooks which return 0 in case of -ENODEV sounds good to me and shall
> incorporate this in the next version.
> 

But from "user_regset_active_fn" definition point of view -ENODEV is the right thing
to do even if we dont use it specifically compared to the return value of 0.

