Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaDVTbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaDVTbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:31:15 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Check for host supported fields in shadow vmcs
References: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>
	<5355E222.7010607@redhat.com> <jpg7g6h72ln.fsf@nelium.bos.redhat.com>
	<5356BF6A.2070801@redhat.com>
Date: Tue, 22 Apr 2014 15:31:12 -0400
In-Reply-To: <5356BF6A.2070801@redhat.com> (Paolo Bonzini's message of "Tue,
	22 Apr 2014 15:13:46 -0400")
Message-ID: <jpg38h5xitb.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 22/04/2014 12:25, Bandan Das ha scritto:
>>>> >> +		if (j < i)
>>>> >> +			shadow_read_write_fields[j] =
>>>> >> +				shadow_read_write_fields[i];
>>>> >> +		j++;
>>> >
>>> > ... you need to respin anyway because the j++ is wrong.  It should be
>>> > inside the "if".  If you prefer, you can put it in the lhs of the
>> j++ outside the "if" looks right to me. Can you please explain why
>> you think it shouldn't be that way ?
>>
>
> The way you wrote it, j will always be equal to i.

Right, and that's what we want unless we come across an unsupported 
field. We then overwrite the unsupported field with the next
field supported. j this way keeps track of the "real" length.

> Paolo
