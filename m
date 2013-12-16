Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3LPTj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:39:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab3LPTjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:39:24 -0500
Message-ID: <52AF56E3.1070404@redhat.com>
Date: Mon, 16 Dec 2013 20:39:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, francis.moro@gmail.com, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH backport hints for <3.10] KVM: x86: Convert vapic synchronization
 to _cached functions (CVE-2013-6368)
References: <1387193897-24658-1-git-send-email-pbonzini@redhat.com> <20131216152446.GA1894@kroah.com>
In-Reply-To: <20131216152446.GA1894@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/12/2013 16:24, Greg KH ha scritto:
> On Mon, Dec 16, 2013 at 12:38:17PM +0100, Paolo Bonzini wrote:
>> The KVM patch "fix vapic memory corruption" applies to most kernels that
>> have KVM, but the fix does not apply on many older branches.  The APIs it
>> uses are available in 3.1, but until 3.9 kvm_gfn_to_hva_cache_init had
>> one fewer parameter.
>>
>> The comments in this patch should help fixing kvm_lapic_set_vapic_addr
>> in older kernels.  I will review the backports as they are posted to
>> LKML (if I am CCed...).
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/lapic.c | 38 +++++++++++++++++++++++++++++---------
>>  arch/x86/kvm/lapic.h |  4 ++--
>>  arch/x86/kvm/x86.c   | 33 +--------------------------------
>>  3 files changed, 32 insertions(+), 43 deletions(-)
> 
> I don't understand, what are people supposed to do with this?

If people want to backport the patch to their stable tree, and the
upstream patch doesn't apply, they can use this as a skeleton.  I was
asked by Francis how to backport the patch, and I think code is a better
tool than text.

It's not a particularly important bug.  It's okay if you don't apply it
anywhere where it doesn't apply cleanly (i.e. 3.10 and newer only), but
the Debian and RT folks may disagree.  If they want to do the backport,
I hope this can help.

Paolo
