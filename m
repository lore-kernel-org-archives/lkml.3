Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3J3Nyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:54:41 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38071 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3J3Nyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:54:39 -0400
Message-ID: <52710FC8.8060309@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 19:25:20 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com> <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com> <52700C24.9050001@linux.vnet.ibm.com> <20131029200012.GA19769@kroah.com>
In-Reply-To: <20131029200012.GA19769@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103013-7014-0000-0000-000003D9B444
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 01:30 AM, Greg KH wrote:
[...]
>> debugfs_create_dir() currently returns NULL dentry on both
>> EEXIST, ENOMEM ... cases.
>>
>> Could one solution be cascading actual error
>> that is lost in fs/debugfs/inode.c:__create_file(), so that we could
>> take correct action in case of failure of debugfs_create_dir()?
>
> What would you do here?  You shouldn't really care about debugfs files,
> if there's an error, keep on going, no code path should really care,
> right?
>
Thanks Greg.

Yes you are right. we can't do anything useful after that error.

If debugfs directories are not critical, may be we could
continue from there.

