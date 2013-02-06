Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3BFVSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956Ab3BFVSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:18:35 -0500
Message-ID: <5112C889.7050308@redhat.com>
Date: Wed, 06 Feb 2013 16:18:01 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 3/4] Add the code to send the consigned time from the
 host to the guest
References: <20130205214818.4615.12937.stgit@lambeau> <20130205214930.4615.37337.stgit@lambeau>
In-Reply-To: <20130205214930.4615.37337.stgit@lambeau>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 04:49 PM, Michael Wolf wrote:
> Change the paravirt calls that retrieve the steal-time information
> from the host.  Add to it getting the consigned value as well as
> the steal time.
>
> Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>

> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 06fdbd9..55d617f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -42,9 +42,10 @@
>
>   struct kvm_steal_time {
>   	__u64 steal;
> +	__u64 consigned;
>   	__u32 version;
>   	__u32 flags;
> -	__u32 pad[12];
> +	__u32 pad[10];
>   };

The function kvm_register_steal_time passes the address of such
a structure to the host kernel, which then does something with
it.

Could running a guest with the above patch, on top of a host
with the old code, result in the values for "version" and
"flags" being written into "consigned"?

Could that result in confusing the guest kernel to no end,
and generally breaking things?
