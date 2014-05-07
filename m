Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaEGI6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:58:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaEGI6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:58:32 -0400
Message-ID: <5369F5B0.7050307@redhat.com>
Date: Wed, 07 May 2014 10:58:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hu Yaohui <loki2441@gmail.com>, Abel Gordon <abel@stratoscale.com>
CC: Bandan Das <bsd@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Muli Ben-Yehuda <muli@stratoscale.com>
Subject: Re: KVM Nested L2 guest startup problems
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>	<53636B1D.8030405@redhat.com>	<CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>	<5363BF42.9020505@redhat.com>	<CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>	<jpgzjj0xbxl.fsf@nelium.bos.redhat.com>	<CAHqbYQuaaUaGTahryghh0nX99msMgeNQr=yv34mbgDJbFeSCbw@mail.gmail.com>	<CAESbUUzDm0REihDHinZ+fmQL8MWqn4kYCY8mQaVEnmVr4hh7NA@mail.gmail.com> <CAHqbYQuv73Wm_9p-_yhYn5C5K9Ag+8Az+sJ_-WEnk9u9Z586Ww@mail.gmail.com>
In-Reply-To: <CAHqbYQuv73Wm_9p-_yhYn5C5K9Ag+8Az+sJ_-WEnk9u9Z586Ww@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/05/2014 18:33, Hu Yaohui ha scritto:
>> I experienced a similar problem that was related to nested code
>> having some bugs related to apicv and other new vmx features.
>>
>> For example, the code enabled posted interrupts to run L2 even when the
>> feature was not exposed to L1 and L1 didn't use it.
>>
>> Try changing prepare_vmcs02  to force disabling posted_interrupts,
>> code should looks like:
>>
>> ....
>> ....
>> exec_control = vmcs12->pin_based_vm_exec_control;
>> exec_control |= vmcs_config.pin_based_exec_ctrl;
>> exec_control &= ~(PIN_BASED_VMX_PREEMPTION_TIMER|PIN_BASED_POSTED_INTR);
>> vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, exec_control);
>> ....
>> ...
>>
>> and also
>>
>> ...
>> ...
>> exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>>      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>>      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>      SECONDARY_EXEC_PAUSE_LOOP_EXITING);

PLE should be left enabled, I think.

Apart from that, I'll change the suggestion into a patch.

Thanks!

Paolo

