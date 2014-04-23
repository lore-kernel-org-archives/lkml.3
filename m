Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbaDWPSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:18:36 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52175 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaDWPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140423151638.GA8526@pd.tnic>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
	<CABPqkBRm8Ux15UY2+hF1TZdVsgVbYV+9XPiuh9m497Mr3oJ0Wg@mail.gmail.com>
	<20140423144538.GN11096@twins.programming.kicks-ass.net>
	<CABPqkBT5xg+zQ45dugHiXM5XFYi+V3gsBmANevx25fE0S0iNXA@mail.gmail.com>
	<20140423150912.GO11096@twins.programming.kicks-ass.net>
	<CABPqkBTSKeza=Ax0yGEfMTq5B8NSQHyvfFBe8qVa-h0dE=UCYg@mail.gmail.com>
	<20140423151638.GA8526@pd.tnic>
Date: Wed, 23 Apr 2014 17:18:29 +0200
Message-ID: <CABPqkBQCVrqtNvva5DD3sE0q=MsJNauKMUv=Vd2GH74v8SsBWQ@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL PMU.
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 5:16 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Apr 23, 2014 at 05:14:33PM +0200, Stephane Eranian wrote:
>> Wouldn't rdmsrl_safe() return 0 on success?
>
> Yes.
>
then the if() test is wrong:
if (!rdmsrl_safe())
   return -1;

Should be:
if (rdmsrl_safe())
  return -1;

Or am I missing something?


> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
