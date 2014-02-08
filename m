Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaBHVoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:44:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42798 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaBHVoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:44:19 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140208202124.GK12219@tassilo.jf.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-2-git-send-email-ak@linux.intel.com> <52F67CD7.5090609@zytor.com> <20140208202124.GK12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 02/17] x86, lto: Disable fancy hweight optimizations for LTO v2
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 08 Feb 2014 13:43:29 -0800
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org
Message-ID: <bbf468ff-4a69-4e51-afc4-d894f459ded7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's fine.

On February 8, 2014 12:21:24 PM PST, Andi Kleen <ak@linux.intel.com> wrote:
>On Sat, Feb 08, 2014 at 10:52:07AM -0800, H. Peter Anvin wrote:
>> On 02/08/2014 12:01 AM, Andi Kleen wrote:
>> > The fancy x86 hweight uses different compiler options for the
>> > hweight file. This does not work with LTO. Just disable the
>optimization
>> > with LTO
>> 
>> No, I'm going to NAK this.  This means not using the POPCNT
>instruction
>> if LTO is enabled, and that really isn't an acceptable option.
>
>I thought the use was obscure?
>
>Ok, suppose can just disable LTO for the file.
>The only drawback is that the functions will not be optimized away when
>not used, as they'll need to be __visible.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
