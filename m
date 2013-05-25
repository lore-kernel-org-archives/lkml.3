Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3EYIcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 04:32:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38631 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3EYIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 04:32:08 -0400
Message-ID: <51A076FE.3060604@gmail.com>
Date: Sat, 25 May 2013 16:31:58 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com> <20130524143644.GD18218@redhat.com> <20130524170626.2ac06efe@holzheu> <20130524152849.GF18218@redhat.com> <87mwrkatgu.fsf@xmission.com> <51A006CF.90105@gmail.com> <87k3mnahkf.fsf@xmission.com>
In-Reply-To: <87k3mnahkf.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月25日 11:01, Eric W. Biederman 写道:
> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
> 
>> Hello Eric,
>>
>>> The function copy_oldmem_page also concerns me.  I don't have a clue why
>>> we duplicate that function on every architecutre in a slightly different
>>> form.  There should be enough abstractions in the kernel to make that
>>> unnecessary.  I would be glad to see that function go, and remove the
>>> possibility of confusion that happened on s390.
>>
>> You mean we should have a common copy_oldmem_page for all architectures? And
>> just like vivek said above, for s390, we should put the swap info in the elf
>> headers instead of doing that in copy_oldmem_page.
> 
> Exactly.
> 
> The user space change in /sbin/kexec should even be backwards compatible
> for s390.  So fixing /sbin/kexec should probably come first.
> 

I am kind of not sure about the "backwards compatible for s390" you meant.

For s390, if we put swap info into the elf header, This will change /sbin/kexec.
But at this point, copy_oldmem_page is still doing the swap when we try to read
the pages among [0 - OLDMEM_SIZE] and [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE].
So removing the swap in copy_oldmem_page should be done at the same time.
New kexec with old kernels would fail and old kexec with new kernels would fail too.

So could you please explain more about the ""backwards compatible". And please
correct me if I am wrong.

Thanks
Zhang


