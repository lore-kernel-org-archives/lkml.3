Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaEGPlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaEGPlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:41:16 -0400
Message-ID: <536A5412.5000403@redhat.com>
Date: Wed, 07 May 2014 17:41:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Abel Gordon <abel@stratoscale.com>
CC: Hu Yaohui <loki2441@gmail.com>, Bandan Das <bsd@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Muli Ben-Yehuda <muli@stratoscale.com>
Subject: Re: KVM Nested L2 guest startup problems
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>	<53636B1D.8030405@redhat.com>	<CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>	<5363BF42.9020505@redhat.com>	<CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>	<jpgzjj0xbxl.fsf@nelium.bos.redhat.com>	<CAHqbYQuaaUaGTahryghh0nX99msMgeNQr=yv34mbgDJbFeSCbw@mail.gmail.com>	<CAESbUUzDm0REihDHinZ+fmQL8MWqn4kYCY8mQaVEnmVr4hh7NA@mail.gmail.com>	<CAHqbYQuv73Wm_9p-_yhYn5C5K9Ag+8Az+sJ_-WEnk9u9Z586Ww@mail.gmail.com>	<5369F5B0.7050307@redhat.com>	<CAESbUUyQJ=BF1otV7XY2VpiM5TH6AxMMqGWCwO0+Mk_51sX_BA@mail.gmail.com>	<536A1AEA.9020309@redhat.com>	<536A1B91.2070103@redhat.com> <CAESbUUyxxLLdmN5oV+NoOF+4z9-xAc6AOXPD7_XhSQ9sKvZYBA@mail.gmail.com>
In-Reply-To: <CAESbUUyxxLLdmN5oV+NoOF+4z9-xAc6AOXPD7_XhSQ9sKvZYBA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 17:30, Abel Gordon ha scritto:
> > ... which we already do.  The only secondary execution controls we allow are
> > APIC page, unrestricted guest, WBINVD exits, and of course EPT.
> 
> But we don't verify if L1  tries to enable the feature for L1 (even if
> it's not exposed)... Or do we ?

Yes, we do:

        if (!vmx_control_verify(vmcs12->cpu_based_vm_exec_control,
              nested_vmx_procbased_ctls_low, nested_vmx_procbased_ctls_high) ||
            !vmx_control_verify(vmcs12->secondary_vm_exec_control,
              nested_vmx_secondary_ctls_low, nested_vmx_secondary_ctls_high) ||
            !vmx_control_verify(vmcs12->pin_based_vm_exec_control,
              nested_vmx_pinbased_ctls_low, nested_vmx_pinbased_ctls_high) ||
            !vmx_control_verify(vmcs12->vm_exit_controls,
              nested_vmx_exit_ctls_low, nested_vmx_exit_ctls_high) ||
            !vmx_control_verify(vmcs12->vm_entry_controls,
              nested_vmx_entry_ctls_low, nested_vmx_entry_ctls_high))
        {
                nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
                return 1;
        }

Paolo
