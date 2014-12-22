Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaLVWt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:49:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46974 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaLVWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:49:25 -0500
Message-ID: <54989FF0.3090300@redhat.com>
Date: Mon, 22 Dec 2014 23:49:20 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleaning up the KVM clock
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com> <20141222133430.GA23631@amt.cnet> <CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>
In-Reply-To: <CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/12/2014 17:03, Andy Lutomirski wrote:
> This is wrong.  The guest *kernel* might not see the intermediate
> state because the kernel (presumably it disabled migration while
> reading pvti), but the guest vdso can't do that and could very easily
> observe pvti while it's being written.

No.  kvm_guest_time_update is called by vcpu_enter_guest, while the vCPU
is not running, so it's entirely atomic from the point of view of the guest.

> I'll send patches for the whole mess, complete with lots of comments,
> after I test them a bit today.

Ok, some comments can certainly help the discussion.

Paolo
