Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaGGRiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:38:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaGGRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:38:44 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
	<53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com>
	<20140704061701.GB3453@kernel> <jpg1ttyhtqw.fsf@redhat.com>
	<20140707084605.GA2904@kernel> <53BA9A91.7090202@redhat.com>
	<jpg38edt6si.fsf@nelium.bos.redhat.com> <53BADA43.8030302@redhat.com>
Date: Mon, 07 Jul 2014 13:38:37 -0400
In-Reply-To: <53BADA43.8030302@redhat.com> (Paolo Bonzini's message of "Mon,
	07 Jul 2014 19:34:59 +0200")
Message-ID: <jpgbnt1rrvm.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 07/07/2014 19:31, Bandan Das ha scritto:
>>> >
>>> > Which patch?  Yours or Bandan's?
>> Why don't we hold off on Wanpeng's patch and instead apply the one I proposed
>> to call check_nested_events() when checking for interrupt in inject_pending_event() ?
>
> Exactly, yours seemed better to apply as a quick regression fix.
>
> Can you post it as a toplevel patch, so that the commit message
> explains what's happening?  Perhaps add a comment in the code as well.

Ok, will do, thanks!

> Paolo
>
>> I think that will take care of https://bugzilla.kernel.org/show_bug.cgi?id=72381
>> too. Once, we figure out what's causing hangs under certain conditions with his
>> patch, we can apply that and revert this change.
>>
>>
