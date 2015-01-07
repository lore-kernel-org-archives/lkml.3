Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbbAGFmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:42:06 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52489 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbAGFmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:42:04 -0500
Message-ID: <54ACC726.80904@redhat.com>
Date: Wed, 07 Jan 2015 06:41:58 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com> <20150105191756.GA31201@amt.cnet> <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com> <20150105224858.GA6846@amt.cnet> <54AB9FFD.6070309@redhat.com> <54ABCE85.6070004@redhat.com> <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com> <20150106181331.GA24590@amt.cnet> <CALCETrXzJkxbUsVgPbKNpBdp32yf=0M=RfseX=u7Mg2Mmsz2VQ@mail.gmail.com>
In-Reply-To: <CALCETrXzJkxbUsVgPbKNpBdp32yf=0M=RfseX=u7Mg2Mmsz2VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/01/2015 19:26, Andy Lutomirski wrote:
> Don't you stil need:
> 
> version++;
> write the rest;
> version++;
> 
> with possible smp_wmb() in there to keep the compiler from messing around?

No, see my other reply.

Separating the version write is a real bug, but that should be all that
it's needed.

> Also, if you do this, can you also make setting and clearing
> STABLE_BIT properly atomic across all vCPUs?  Or at least do something
> like setting it last and clearing it first on vPCU 0?

That would be nice if you want to make the pvclock area fit in a single
page.  However, it would have to be a separate flag bit, or a separate
CPUID feature.

Paolo
