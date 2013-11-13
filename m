Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab3KMH5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:57:41 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61667 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab3KMH5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:57:35 -0500
In-Reply-To: <alpine.DEB.2.02.1311121956480.30673@ionos.tec.linutronix.de>
References: <20130131002344.1161E360095@xplor.waratah.dyndns.org> <CAMuHMdUFuNpiZzTr=86Yi2yx73xh_qv8S6PnT0hp9U8x86vskw@mail.gmail.com> <CAMuHMdXB1LNGXkz=_eCQ+i+tu18ffbCA9dP_LRrF1CUBv-q-uQ@mail.gmail.com> <alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de> <753aef27d368410b1e5c5814b1e7c8a7@gmail.com> <alpine.DEB.2.02.1311121956480.30673@ionos.tec.linutronix.de>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1d531dbddb96cdcb0dfbc1183ee6d443@gmail.com>
Content-Transfer-Encoding: 7bit
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 09/17] [m68k] IRQ: add handle_polled_irq() for timer based soft interrupts
Date: Wed, 13 Nov 2013 20:57:23 +1300
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

>> I suppose setting the flag can be done in the corresponding irq 
>> startup
>> function, instead of when setting up the irq controller?
>
> irq_startup() is called with irq_desc->lock held and
> irq_set_status_flags() wants desc->lock as well. Deadlock

Thanks, point taken.

> And no, you don't want to fiddle manually in the irq descriptor data
> fields. See commit a6967caf00eb :)

I'm not that crazy :-)

>
>> Geert - I will send the patch to ataints.c implementing this as soon 
>> as
>> Thomas' fix is merged.
>
> I'll expedite it for 3.13.

Thanks, that'll help.

Cheers,

	Michael


>
> Thanks,
>
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

