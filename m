Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaDNWK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:10:27 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:38041 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755512AbaDNWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140412.165549.1068958710661824002.davem@davemloft.net>
References: <1397271984-23405-1-git-send-email-isubramanian@apm.com>
	<1397271984-23405-5-git-send-email-isubramanian@apm.com>
	<20140412.165549.1068958710661824002.davem@davemloft.net>
Date: Mon, 14 Apr 2014 15:09:26 -0700
Message-ID: <CAKh23Fn2-P3QAntShpjBV027POgYfxmCFh3H3KZ5dSpUpa+4yQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] drivers: net: Add APM X-Gene SoC ethernet driver support.
From: Iyappan Subramanian <isubramanian@apm.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "jcm@redhat.com" <jcm@redhat.com>, patches <patches@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for the review comments.  Please find my responses inline.

Thanks,
Iyappan

On Sat, Apr 12, 2014 at 1:55 PM, David Miller <davem@davemloft.net> wrote:
> From: Iyappan Subramanian <isubramanian@apm.com>
> Date: Fri, 11 Apr 2014 20:06:24 -0700
>
>> This patch adds network driver for APM X-Gene SoC ethernet.
>>
>> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
>> Signed-off-by: Ravi Patel <rapatel@apm.com>
>> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
>
> This driver is going to take a long to review and get to the point
> where it can be integrated upstream, I'm just trying to set your
> expectations properly.
Okay.
>
>> +inline void set_desc(struct xgene_enet_desc *desc, enum desc_info_index index,
>> +                  u64 val)
>> +{
>
> The "inline" tag is not necessary, let the compiler figure it out.
Okay.  I will remove inline keyword from the code.
>
>> +     u8 word_index = desc_info[index].word_index;
>> +     u8 start_bit = desc_info[index].start_bit;
>> +     u8 len = desc_info[index].len;
>> +
>> +     u64 mask = GENMASK_ULL((start_bit + len - 1), start_bit);
>> +     ((u64 *)desc)[word_index] = (((u64 *)desc)[word_index] & ~mask)
>> +         | (((u64) val << start_bit) & mask);
>
> This looks horrible for several reasons.
>
> First of all, do not put empty lines in the middle of a set of
> local variable declarations.
>
> But do put a single empty line after the last local variable, and
> before the actual code of the function starts.
>
> Get rid of all of this excessive casting.  Tell the compiler what you're
> actually doing, pass 'desc' in as "void *" and use local "u64 *" pointers
> (to which 'desc' is assigned to) if you must.
I will fix this in the next patch.
