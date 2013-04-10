Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab3DJEKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:10:40 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:49757 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3DJEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <1365563297-12480-3-git-send-email-robherring2@gmail.com>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
	<1365563297-12480-3-git-send-email-robherring2@gmail.com>
Date: Tue, 9 Apr 2013 21:10:37 -0700
X-Google-Sender-Auth: 1a-V2zTnGb3VxODmtL1PcAxesEc
Message-ID: <CAMbhsRSNPz1d9bGGEjqyTwVg_1pv8PB15WybEL5ZRVgmnTDWLQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] pstore/ram: avoid atomic accesses for ioremapped regions
From: Colin Cross <ccross@android.com>
To: Rob Herring <robherring2@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 8:08 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> For persistent RAM outside of main memory, the memory may have limitations
> on supported accesses. For internal RAM on highbank platform exclusive
> accesses are not supported and will hang the system. So atomic_cmpxchg
> cannot be used. This commit uses spinlock protection for buffer size and
> start updates on ioremapped regions instead.

I used atomics in persistent_ram to support persistent ftrace, which
now exists as PSTORE_FTRACE.  At some point during development I had
trouble with recursive tracing causing an infinite loop, so you may
want to test that calling out to spinlock functions with PSTORE_FTRACE
turned on and enabled doesn't cause a problem.
