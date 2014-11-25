Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKYRiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:38:11 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57191 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaKYRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:38:10 -0500
Message-ID: <5474BE7C.5040909@redhat.com>
Date: Tue, 25 Nov 2014 18:38:04 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
References: <20141125172108.992070524@redhat.com> <20141125172329.580701786@redhat.com>
In-Reply-To: <20141125172329.580701786@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/11/2014 18:21, Marcelo Tosatti wrote:
> +
> +	if (r == HRTIMER_RESTART) {
> +		do {
> +			ret = hrtimer_start_expires(data, HRTIMER_MODE_ABS);
> +			if (ret == -ETIME)
> +				hrtimer_add_expires_ns(&ktimer->timer,
> +							ktimer->period);

Is it possible to just compute the time where the next interrupt
happens?  I suspect the printk and WARN_ON below can be easily triggered
by a guest.

Paolo

> +			i++;
> +		} while (ret == -ETIME && i < 10);
> +
> +		if (ret == -ETIME) {
> +			printk(KERN_ERR "%s: failed to reprogram timer\n",
> +			       __func__);
> +			WARN_ON(1);
> +		}
> +	}
