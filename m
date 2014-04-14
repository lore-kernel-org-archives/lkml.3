Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaDNOB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaDNOBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:01:55 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 6/6] KVM: emulate: remove memopp and rip_relative
References: <1397174612-17373-1-git-send-email-bsd@redhat.com>
	<1397174612-17373-7-git-send-email-bsd@redhat.com>
	<534A87A0.9080809@redhat.com>
Date: Mon, 14 Apr 2014 10:01:51 -0400
In-Reply-To: <534A87A0.9080809@redhat.com> (Paolo Bonzini's message of "Sun,
	13 Apr 2014 08:48:32 -0400")
Message-ID: <jpgsipgc8mo.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 10/04/2014 20:03, Bandan Das ha scritto:
>>  	/* Fields above regs are cleared together. */
>
> This comment is not accurate anymore after patch 4.  Since you're
> fixing it, please add another comment saying where the cleared fields
> start, too.

Oops, I forgot to change the comment appropriately. 
Will fix in next version.

Bandan

>> +	ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
>
> This is missing "if (ctxt->ad_bytes != 8)".
>
>> +	if (rip_relative)
>> +		ctxt->memop.addr.mem.ea += ctxt->_eip;
>
> Paolo
