Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3JaSll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:41:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61087 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3JaSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:41:40 -0400
Message-ID: <5272A45B.20507@linaro.org>
Date: Thu, 31 Oct 2013 14:41:31 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/13] uprobes: allow arch-specific initialization
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-5-git-send-email-dave.long@linaro.org> <20131019164223.GB7837@redhat.com> <52672484.9010201@linaro.org> <20131028185818.GB12863@redhat.com>
In-Reply-To: <20131028185818.GB12863@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 14:58, Oleg Nesterov wrote:
> On 10/22, David Long wrote:
> I simply do not understand why uprobes.c uses module_init/module_exit,
> it can't be compiled as a module.

I guess that makes sense, assuming it can never be made a module.  I saw 
you recent commit for this.

> I think that module_exit/exit_uprobes should be killed, and module_init()
> should be turned into __initcall(). uprobes-arm.c can have another one.
>

I will see if I can make this work.  Right now the arch-specific 
initialization call is done in the middle of the generic initialization 
code, but I don't know that it *has* to be that way.  I have some 
concern too about getting the order right, since these are built from 
different makefiles.

-dl

