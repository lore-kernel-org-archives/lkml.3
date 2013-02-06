Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3BFRGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:06:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3BFRGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:06:37 -0500
Message-ID: <51128D56.9080204@redhat.com>
Date: Wed, 06 Feb 2013 12:05:26 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual machines
References: <20130125140553.060b8ced@annuminas.surriel.com> <20130125141917.6d5960a8@annuminas.surriel.com> <20130126120043.GB13445@gmail.com> <20130126124716.GB21395@pd.tnic> <510FBCA9.4070700@redhat.com> <20130204140203.GB15452@pd.tnic>
In-Reply-To: <20130204140203.GB15452@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 09:02 AM, Borislav Petkov wrote:
> On Mon, Feb 04, 2013 at 08:50:33AM -0500, Rik van Riel wrote:
>> We need to know whether we are actually running on top of a
>> hypervisor, not whether we have the code compiled in to do so.
>
> Oh ok, I see.
>
> The thing is, if CONFIG_PARAVIRT_GUEST is disabled, x86_hyper won't
> exist, see: http://marc.info/?l=linux-kernel&m=135936817627848&w=2
>
> So maybe the hypervisor guest should itself take care of this and upon
> init it should set the max_spinlock_delay in init_hypervisor() instead?
> Seems only fair to me...

I ended up making the call from init_hypervisor_platform, which
already does the check for x86_hyper itself, allowing me to not
check x86_hyper at all from smp.c

