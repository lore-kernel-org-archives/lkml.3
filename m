Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaCMTfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:35:45 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60382 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaCMTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <87wqfyf27g.fsf@tassilo.jf.intel.com>
References: <20140313120436.GA14236@quad>
	<87wqfyf27g.fsf@tassilo.jf.intel.com>
Date: Thu, 13 Mar 2014 20:35:43 +0100
Message-ID: <CABPqkBSSF3wUXsK-NPd83RPUEvOaJ3jcQuXbBpF7SdXwNtre2w@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: fix missing end markers for SNB/IVB/HSW
 IMC PMU
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 6:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephane Eranian <eranian@google.com> writes:
>
>> This patch fixes a bug with the SNB/IVB/HSW uncore
>> mmeory controller support.
>>
>> The PCI Ids tables for the memory controller were missing end markers.
>> That could cause random crashes on boot during or after PCI device
>> registration.
>
> I wonder if there's a way to check this in checkpatch.pl ?
>
> Or maybe a sparse check could be added, with a new type attribute
> that says "needs to be 0 terminate"
>
Not that easy , because in some cases, the size may be passed as a parameter
to the call or maybe embedded into a struct passed to the call.
But if you target this specific macro, you should be able to find the issues.

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
