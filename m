Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaEZMxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaEZMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:53:32 -0400
Message-ID: <53833944.6030605@redhat.com>
Date: Mon, 26 May 2014 14:53:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wei Huang <huangwei.virt@gmail.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: Re: [PATCH v2 0/4] KVM: x86: get CPL from SS.DPL
References: <CALeycy_8q9jcbwCGp6qpcN8TyH7Ve2WUxCbo+kcd_bHYzXDqOA@mail.gmail.com> <CALeycy-hH7=S5tLo1TWQTqGpwsjjx6_c3yaJZs0Vywyv-fZQaQ@mail.gmail.com>
In-Reply-To: <CALeycy-hH7=S5tLo1TWQTqGpwsjjx6_c3yaJZs0Vywyv-fZQaQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/05/2014 00:58, Wei Huang ha scritto:
> If so , my question: is there other special cases similar to task switch
> which can break patch 4?

I don't think so.  CPL can only change when SS is loaded, i.e. for 
inter-privilege transfers that aren't far calls or far jumps to a 
conforming code segment.

I count only three such cases (protected mode int, protected mode iret, 
call gate), none of which is implemented in the KVM emulator.  In fact, 
the emulator doesn't implement task gates either---luckily all 
information about the destination task is provided by the processor in 
the VMCB or VMCS.

Paolo
