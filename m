Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161463AbaKNSiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:38:09 -0500
Received: from www.sr71.net ([198.145.64.142]:60040 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaKNSiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:38:07 -0500
Message-ID: <54664C0B.6070604@sr71.net>
Date: Fri, 14 Nov 2014 10:38:03 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, hpa@zytor.com
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 05/11] x86, mpx: add MPX to disaabled features
References: <20141114151816.F56A3072@viggo.jf.intel.com> <20141114151823.B358EAD2@viggo.jf.intel.com> <5466425D.1060100@cogentembedded.com>
In-Reply-To: <5466425D.1060100@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 09:56 AM, Sergei Shtylyov wrote:
>>   #define DISABLED_MASK6    0
>>   #define DISABLED_MASK7    0
>>   #define DISABLED_MASK8    0
>> -#define DISABLED_MASK9    0
>> +#define DISABLED_MASK9    (DISABLE_MPX)
> 
>    These parens are not really needed. Sorry to be a PITA and not saying
> this before.

One goal of the disabled features patch was to maintain parity with
required-features.h.  It declares things this way:

> #define REQUIRED_MASK3  (NEED_NOPL)
> #define REQUIRED_MASK4  (NEED_MOVBE)

So, no, those aren't strictly needed, but there is precedent for them
and they do no harm.  I think I'll leave them as-is.
