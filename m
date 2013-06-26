Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3FZHqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:46:53 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:39763 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FZHqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:46:50 -0400
Message-ID: <51CA9C5E.1030609@redhat.com>
Date: Wed, 26 Jun 2013 09:46:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 29/45] kvm/vmx: Use get/put_online_cpus_atomic() to
 prevent CPU offline
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com> <20130625203043.16593.1600.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130625203043.16593.1600.stgit@srivatsabhat.in.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/06/2013 22:30, Srivatsa S. Bhat ha scritto:
> -	cpu = get_cpu();
> +	cpu = get_online_cpus_atomic();
>  	vmx_vcpu_load(&vmx->vcpu, cpu);
>  	vmx->vcpu.cpu = cpu;
>  	err = vmx_vcpu_setup(vmx);
>  	vmx_vcpu_put(&vmx->vcpu);
> -	put_cpu();
> +	put_online_cpus_atomic();

The new API has a weird name.  Why are you adding new functions instead
of just modifying get/put_cpu?

Paolo
