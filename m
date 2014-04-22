Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbaDVQ0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:26:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbaDVQZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:25:59 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Check for host supported fields in shadow vmcs
References: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>
	<5355E222.7010607@redhat.com>
Date: Tue, 22 Apr 2014 12:25:56 -0400
In-Reply-To: <5355E222.7010607@redhat.com> (Paolo Bonzini's message of "Mon,
	21 Apr 2014 23:29:38 -0400")
Message-ID: <jpg7g6h72ln.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 21/04/2014 15:20, Bandan Das ha scritto:
>> +	for (i = j = 0; i < max_shadow_read_write_fields; i++) {
>> +
>
> Extra empty line.  Not a big deal, but...
>
>> +		switch (shadow_read_write_fields[i]) {
>> +		case GUEST_BNDCFGS:
>> +			if (!vmx_mpx_supported())
>> +				continue;
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +
>> +		if (j < i)
>> +			shadow_read_write_fields[j] =
>> +				shadow_read_write_fields[i];
>> +		j++;
>
> ... you need to respin anyway because the j++ is wrong.  It should be
> inside the "if".  If you prefer, you can put it in the lhs of the

j++ outside the "if" looks right to me. Can you please explain why
you think it shouldn't be that way ?

> assignment, otherwise a separate statement is fine by me too.
>
> Paolo
