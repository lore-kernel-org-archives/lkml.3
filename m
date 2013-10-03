Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3JCL4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab3JCL4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:56:12 -0400
Message-ID: <524D5B6E.9020605@redhat.com>
Date: Thu, 03 Oct 2013 13:56:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: mmu: remove uninteresting MMU "new_cr3" callbacks
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com> <1380725776-14948-3-git-send-email-pbonzini@redhat.com> <20131003102305.GC17294@redhat.com>
In-Reply-To: <20131003102305.GC17294@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/10/2013 12:23, Gleb Natapov ha scritto:
>> > The commit message mentioned that "mmu_free_roots() is somewhat of an overkill,
>> > but fixing that is more complicated and will be done after this minimal fix".
>> > One year has passed, and no one really felt the need to do a different fix.
>> > Wrap the call with a kvm_mmu_new_cr3 function for clarity, but remove the
>> > callback.
>> > 
> Well the reason for it is because whoever knew about the problem found
> other things to do meanwhile :) But do we really need something smarter
> here anyway? The situation described in e676505 should be extremely rare
> even on non unrestricted guest HW and it happens during slow emulation
> anyway, so optimization will likely not be noticeable.

Yeah, and it's not like code that runs without paging will move to cr3
in a hot loop. :)

Paolo
