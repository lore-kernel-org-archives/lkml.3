Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3JVL0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:26:20 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34666 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3JVL0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:26:19 -0400
Date: Tue, 22 Oct 2013 07:25:51 -0400 (EDT)
From: Oleg Nesterov <onestero@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <1641249240.11471136.1382441151287.JavaMail.root@redhat.com>
In-Reply-To: <5265F4EB.2060803@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-3-git-send-email-dave.long@linaro.org> <20131019170214.GA8324@redhat.com> <5265F4EB.2060803@linaro.org>
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC26 (Linux)/8.0.3_GA_5664)
Thread-Topic: uprobes: allow ignoring of probe hits
Thread-Index: AenQjQRSXqe6GV/zPeECt97aykg92Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top-posting/formatting,

Do you mean arch_uprobe_skip_sstep() ?

Yes, this __weak is wrong, already fixed in my tree. See
http://marc.info/?l=linux-mips&m=138132052022388&w=2

----- Original Message -----
From: "David Long" <dave.long@linaro.org>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, "Rabin Vincent" <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>, "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>, "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org
Sent: Tuesday, 22 October, 2013 5:45:47 AM
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits

On 10/19/13 13:02, Oleg Nesterov wrote:
> On 10/15, David Long wrote:
>>
>> @@ -1732,9 +1732,6 @@ static void handle_swbp(struct pt_regs *regs)
>>   		return;
>>   	}
>>
>> -	/* change it in advance for ->handler() and restart */
>> -	instruction_pointer_set(regs, bp_vaddr);
>> -
>
> Well, this looks obviously wrong. This SET_IP() has the comment ;)
>
> Note also that with this breaks __skip_sstep() on x86.
>
> Oleg.
>

Yes, and there's a missing weak stub function in there too.  It was a 
surprise to me that declaring an external as weak means that it quietly 
ignores the fact there is no definition for it at link time, and makes 
it zero.  I think there may be some similar land mines elsewhere in the 
kernel, unrelated to these changes or uprobes in general.

I have an updated version to go out with the v3 patches.  It is working 
with v3.12-rc6 on x86 and ARM, to the extent I'm able to test it.

-dl
