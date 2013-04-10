Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936990Ab3DJPzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:55:39 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56407 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935973Ab3DJPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:55:38 -0400
Message-ID: <51658B77.4050400@gmail.com>
Date: Wed, 10 Apr 2013 10:55:35 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC PATCH 3/3] pstore/ram: avoid atomic accesses for ioremapped
 regions
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com> <1365563297-12480-3-git-send-email-robherring2@gmail.com> <CAMbhsRSNPz1d9bGGEjqyTwVg_1pv8PB15WybEL5ZRVgmnTDWLQ@mail.gmail.com>
In-Reply-To: <CAMbhsRSNPz1d9bGGEjqyTwVg_1pv8PB15WybEL5ZRVgmnTDWLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 11:10 PM, Colin Cross wrote:
> On Tue, Apr 9, 2013 at 8:08 PM, Rob Herring <robherring2@gmail.com> wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> For persistent RAM outside of main memory, the memory may have limitations
>> on supported accesses. For internal RAM on highbank platform exclusive
>> accesses are not supported and will hang the system. So atomic_cmpxchg
>> cannot be used. This commit uses spinlock protection for buffer size and
>> start updates on ioremapped regions instead.
> 
> I used atomics in persistent_ram to support persistent ftrace, which
> now exists as PSTORE_FTRACE.  At some point during development I had
> trouble with recursive tracing causing an infinite loop, so you may
> want to test that calling out to spinlock functions with PSTORE_FTRACE
> turned on and enabled doesn't cause a problem.

I've tested that now and it appears to work fine. Was there some
specific setup of ftrace that caused problems?

Rob

