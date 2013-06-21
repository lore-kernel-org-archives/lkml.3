Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946074Ab3FUUrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:47:55 -0400
Received: from [207.46.163.236] ([207.46.163.236]:12243 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945963Ab3FUUry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:47:54 -0400
Message-ID: <51C4BB86.1020004@caviumnetworks.com>
Date: Fri, 21 Jun 2013 13:45:58 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: David Daney <ddaney.cavm@gmail.com>, James Hogan <james.hogan@imgtec.com>,
        <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kees Cook" <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com>
In-Reply-To: <20130621202244.GA16610@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-Antispam-Report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:0;SRVR:SN2PR07MB016;H:BN1PRD0712HT002.namprd07.prod.outlook.com;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 01:22 PM, Oleg Nesterov wrote:
> On 06/21, David Daney wrote:
>>
>> On 06/21/2013 06:39 AM, James Hogan wrote:
>>> Therefore add sig_to_exitcode() and exitcode_to_sig() functions which
>>> map signal numbers > 126 to exit code 126 and puts the remainder (i.e.
>>> sig - 126) in higher bits. This allows WIFSIGNALED() to return true for
>>> both SIG127 and SIG128, and allows WTERMSIG to be later updated to read
>>> the correct signal number for SIG127 and SIG128.
>>
>> I really hate this approach.
>>
>> Can we just change the ABI to reduce the number of signals so that all
>> the standard C library wait related macros don't have to be changed?
>>
>> Think about it, any user space program using signal numbers 127 and 128
>> doesn't work correctly as things exist today, so removing those two will
>> be no great loss.
>
> Oh, I agree.
>
> Besides, this changes ABI anyway. And if we change it we can do this in
> a more clean way, afaics. MIPS should simply use 2 bytes in exit_code for
> signal number.

Wouldn't that break *all* existing programs that use signals?  Perhaps I 
misunderstand what you are suggesting.

I am proposing that we just reduce the number of usable signals such 
that existing libc status checking macros/functions don't change in any way.

  Yes, this means we need replace 0x80/0x7f in exit.c by
> ifdef'ed numbers. And yes, this means that WIFSIGNALED/etc should be
> updated too, but this is also true with this patch.
>
> Oleg.
>
>

