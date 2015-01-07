Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbbAGJAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:00:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54862 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbbAGJAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:00:39 -0500
Message-ID: <54ACF5AC.4030700@redhat.com>
Date: Wed, 07 Jan 2015 10:00:28 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com> <20150105191756.GA31201@amt.cnet> <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com> <20150105224858.GA6846@amt.cnet> <54AB9FFD.6070309@redhat.com> <54ABCE85.6070004@redhat.com> <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com> <54ACC64F.6030304@redhat.com> <CALCETrXGGV9R_4Knz_0LTaz3X2PS1KJDdBfq_RHAVquKdUjrYQ@mail.gmail.com>
In-Reply-To: <CALCETrXGGV9R_4Knz_0LTaz3X2PS1KJDdBfq_RHAVquKdUjrYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/01/2015 08:18, Andy Lutomirski wrote:
>>> >> Thus far, I've been told unambiguously that a guest can't observe pvti
>>> >> while it's being written, and I think you're now telling me that this
>>> >> isn't true and that a guest *can* observe pvti while it's being
>>> >> written while the low bit of the version field is not set.  If so,
>>> >> this is rather strongly incompatible with the spec in the KVM docs.
>> >
>> > Where am I saying that?
> I thought the conclusion from what you and Marcelo pointed out about
> the code was that, once the first vCPU updated its pvti, it could
> start running guest code while the other vCPUs are still updating
> pvti, so its guest code can observe the other vCPUs mid-update.

Ah, in that sense you're right.  However, each VCPU cannot observe _its
own_ pvti entry while it's being written (no matter what's in the low
bit of the version field).

Paolo
