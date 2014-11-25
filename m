Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKYTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:01:37 -0500
Received: from david.siemens.de ([192.35.17.14]:43217 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaKYTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:01:36 -0500
Message-ID: <5474D208.4080009@siemens.com>
Date: Tue, 25 Nov 2014 20:01:28 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
References: <20141125172108.992070524@redhat.com> <20141125172329.580701786@redhat.com> <5474BE7C.5040909@redhat.com>
In-Reply-To: <5474BE7C.5040909@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-25 18:38, Paolo Bonzini wrote:
> 
> 
> On 25/11/2014 18:21, Marcelo Tosatti wrote:
>> +
>> +	if (r == HRTIMER_RESTART) {
>> +		do {
>> +			ret = hrtimer_start_expires(data, HRTIMER_MODE_ABS);
>> +			if (ret == -ETIME)
>> +				hrtimer_add_expires_ns(&ktimer->timer,
>> +							ktimer->period);
> 
> Is it possible to just compute the time where the next interrupt
> happens?  I suspect the printk and WARN_ON below can be easily triggered
> by a guest.

We have a lower bound for the period that a guest can program. Unless
that value is set too low, this should practically not happen if we
avoid disturbances while handling the event and reprogramming the next
one (irqs off?).

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
