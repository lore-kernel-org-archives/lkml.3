Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575AbaDJMiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030461AbaDJMiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:38:20 -0400
Message-ID: <534690A4.8010003@redhat.com>
Date: Thu, 10 Apr 2014 14:37:56 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/6] uprobes/x86: Emulate unconditional rip-relative
 jmp's
References: <20140409194427.GA6221@redhat.com>
In-Reply-To: <20140409194427.GA6221@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:44 PM, Oleg Nesterov wrote:
> uprobes/x86: Emulate unconditional rip-relative jmp's

I propose "Emulate unconditional relative jmp's"


> +	union {
>  #ifdef CONFIG_X86_64
> -	unsigned long			rip_rela_target_address;
> +		unsigned long			rip_rela_target_address;
>  #endif
> +		struct {
> +			s32	disp;

In x86-speak, jumps and calls have "offsets", not "displacements"

> +			u8	ilen;
> +		}				ttt;
> +	};
>  };

