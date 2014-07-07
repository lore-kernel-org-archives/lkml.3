Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaGGXNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:13:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:60282 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaGGXM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:12:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="360021816"
Date: Tue, 8 Jul 2014 07:14:01 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Bandan Das <bsd@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140707231401.GA5759@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
 <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
 <20140704061701.GB3453@kernel>
 <jpg1ttyhtqw.fsf@redhat.com>
 <20140707084605.GA2904@kernel>
 <53BA9A91.7090202@redhat.com>
 <jpg38edt6si.fsf@nelium.bos.redhat.com>
 <53BADA43.8030302@redhat.com>
 <jpgbnt1rrvm.fsf@nelium.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpgbnt1rrvm.fsf@nelium.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 01:38:37PM -0400, Bandan Das wrote:
>Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> Il 07/07/2014 19:31, Bandan Das ha scritto:
>>>> >
>>>> > Which patch?  Yours or Bandan's?
>>> Why don't we hold off on Wanpeng's patch and instead apply the one I proposed
>>> to call check_nested_events() when checking for interrupt in inject_pending_event() ?
>>
>> Exactly, yours seemed better to apply as a quick regression fix.
>>
>> Can you post it as a toplevel patch, so that the commit message
>> explains what's happening?  Perhaps add a comment in the code as well.
>
>Ok, will do, thanks!

As Jan metioned in http://www.spinics.net/lists/kvm/msg105238.html, "In any case, 
unconditionally setting KVM_REQ_EVENT seems strange and should be changed." Your 
trick still keep the unconditionally setting KVM_REQ_EVENT which is the root cause 
of the race there, anyway, I focus on fix the hang currently and a patch will be 
submitted soon. 

Regards,
Wanpeng Li 

>
>> Paolo
>>
>>> I think that will take care of https://bugzilla.kernel.org/show_bug.cgi?id=72381
>>> too. Once, we figure out what's causing hangs under certain conditions with his
>>> patch, we can apply that and revert this change.
>>>
>>>
