Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbbAGJWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:22:32 -0500
Received: from mail113-249.mail.alibaba.com ([205.204.113.249]:58736 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752610AbbAGJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:22:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41f05021;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=11;RT=11;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Wang Nan'" <wangnan0@huawei.com>
Cc: <linux@arm.linux.org.uk>, "Ingo Molnar" <mingo@redhat.com>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>, <lizefan@huawei.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 09/11] kprobes: core logic of eraly kprobes
Date: Wed, 07 Jan 2015 17:21:07 +0800
Message-ID: <043a01d02a5b$44ec45f0$cec4d1d0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAqV9jOPreG3ZtVR4e5xDLKmL8GUw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> +struct early_kprobe_slot {
> +	struct optimized_kprobe op;
> +};
> +
[...]
> 
>  /* Free optimized instructions and optimized_kprobe */
> +static int ek_free_early_kprobe(struct early_kprobe_slot *slot);

[2] How is it implemented? In subsequent patches?

>  static void free_aggr_kprobe(struct kprobe *p)
>  {
>  	struct optimized_kprobe *op;
> +	struct early_kprobe_slot *ep;
> 
>  	op = container_of(p, struct optimized_kprobe, kp);
>  	arch_remove_optimized_kprobe(op);
>  	arch_remove_kprobe(p);
> -	kfree(op);
> +	ep = container_of(op, struct early_kprobe_slot, op);
> +	if (likely(!ek_free_early_kprobe(ep)))
> +		kfree(op);

[1] s/op/ep/   yes?
>  }
> 
[...]
> +#else
> +static int register_early_kprobe(struct kprobe *p) { return -ENOSYS; }
> +static int ek_free_early_kprobe(struct early_kprobe_slot *slot) { return 0; }

[3] Compile-able with CONFIG_EARLY_KPROBES enabled?

> +static void convert_early_kprobes(void) {};
> +#endif
> --
> 1.8.4

