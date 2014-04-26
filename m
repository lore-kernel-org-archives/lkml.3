Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaDZJmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:42:44 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59073 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaDZJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:42:39 -0400
Message-ID: <535B7F8D.10609@redhat.com>
Date: Sat, 26 Apr 2014 11:42:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Check for host supported fields in shadow
 vmcs
References: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>	<5355E222.7010607@redhat.com> <jpg7g6h72ln.fsf@nelium.bos.redhat.com>	<5356BF6A.2070801@redhat.com> <jpg38h5xitb.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpg38h5xitb.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/04/2014 21:31, Bandan Das ha scritto:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> Il 22/04/2014 12:25, Bandan Das ha scritto:
>>>>>>> +		if (j < i)
>>>>>>> +			shadow_read_write_fields[j] =
>>>>>>> +				shadow_read_write_fields[i];
>>>>>>> +		j++;
>>>>>
>>>>> ... you need to respin anyway because the j++ is wrong.  It should be
>>>>> inside the "if".  If you prefer, you can put it in the lhs of the
>>> j++ outside the "if" looks right to me. Can you please explain why
>>> you think it shouldn't be that way ?
>>>
>>
>> The way you wrote it, j will always be equal to i.
>
> Right, and that's what we want unless we come across an unsupported
> field. We then overwrite the unsupported field with the next
> field supported. j this way keeps track of the "real" length.

Doh, brain fart.

Paolo

