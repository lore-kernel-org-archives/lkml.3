Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaDKX7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 19:59:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49072 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaDKX7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 19:59:51 -0400
Message-ID: <534881DB.40901@zytor.com>
Date: Fri, 11 Apr 2014 16:59:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com
Subject: Re: [PATCH V1 1/1] X86: Probe for PIC and set legacy_pic appropriately
References: <1397263802-5934-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1397263802-5934-1-git-send-email-kys@microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 05:50 PM, K. Y. Srinivasan wrote:
>  
> +	/*
> +	 * Check to see if we have a PIC.
> +	 * Mask all except the cascade and read
> +	 * back the value we just wrote. If we don't
> +	 * have a PIC, we will read 0xff as opposed to the
> +	 * value we wrote.
> +	 */
> +	outb(probe_val, PIC_MASTER_IMR);
> +	probe_val = inb(PIC_MASTER_IMR);
> +	if (probe_val == 0xff) {
> +		printk(KERN_INFO "Using NULL legacy PIC\n");
> +		legacy_pic = &null_legacy_pic;
> +		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
> +		return;
> +	}
> +
>  	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
>  	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
>  

Again, I would do at least the slave masking above the probe.

Also, I would compare to make sure we get the probe_val back and compare
with != instead of comparing with ==.

	-hpa


