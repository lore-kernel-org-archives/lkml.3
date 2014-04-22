Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaDVD0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:26:40 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:36168 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaDVD0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:26:38 -0400
Message-ID: <5355E145.9000406@redhat.com>
Date: Mon, 21 Apr 2014 23:25:57 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: vmx: speed up emulation of invalid guest
 state
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com> <1395919838-18466-2-git-send-email-pbonzini@redhat.com> <20140416225258.GA19597@amt.cnet> <5350A7D0.8070603@redhat.com> <20140421021333.GA18207@amt.cnet>
In-Reply-To: <20140421021333.GA18207@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/04/2014 22:13, Marcelo Tosatti ha scritto:
> The same code which resets it to false inside the
> handle_invalid_guest_state loop (so you would stop emulating
> at the same point as you do with this patch).

So (barring any bugs where we fail to set vmx->emulation_required to 
true) the "vmx->emulation_required = true;" on vmentry error would be 
dead code.

> Advantage would be that failure to set vmx->emulation_required to
> true would not cause VM-entry failure.

A place where we fail to set vmx->emulation_required to true is quite 
likely to also be wrong when setting vmx->emulation_required to false. 
Since this is not something that has ever seen much churn, I think it's 
better to code it in a way that shows bugs easily.  The bugs do not 
affect the host anyway.

Paolo
