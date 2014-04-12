Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaDLUzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 16:55:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38684 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbaDLUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 16:55:51 -0400
Date: Sat, 12 Apr 2014 16:55:49 -0400 (EDT)
Message-Id: <20140412.165549.1068958710661824002.davem@davemloft.net>
To: isubramanian@apm.com
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        rapatel@apm.com, kchudgar@apm.com
Subject: Re: [PATCH v2 4/4] drivers: net: Add APM X-Gene SoC ethernet
 driver support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397271984-23405-5-git-send-email-isubramanian@apm.com>
References: <1397271984-23405-1-git-send-email-isubramanian@apm.com>
	<1397271984-23405-5-git-send-email-isubramanian@apm.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 12 Apr 2014 13:55:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iyappan Subramanian <isubramanian@apm.com>
Date: Fri, 11 Apr 2014 20:06:24 -0700

> This patch adds network driver for APM X-Gene SoC ethernet.
> 
> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
> Signed-off-by: Ravi Patel <rapatel@apm.com>
> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>

This driver is going to take a long to review and get to the point
where it can be integrated upstream, I'm just trying to set your
expectations properly.

> +inline void set_desc(struct xgene_enet_desc *desc, enum desc_info_index index,
> +		     u64 val)
> +{

The "inline" tag is not necessary, let the compiler figure it out.

> +	u8 word_index = desc_info[index].word_index;
> +	u8 start_bit = desc_info[index].start_bit;
> +	u8 len = desc_info[index].len;
> +
> +	u64 mask = GENMASK_ULL((start_bit + len - 1), start_bit);
> +	((u64 *)desc)[word_index] = (((u64 *)desc)[word_index] & ~mask)
> +	    | (((u64) val << start_bit) & mask);

This looks horrible for several reasons.

First of all, do not put empty lines in the middle of a set of
local variable declarations.

But do put a single empty line after the last local variable, and
before the actual code of the function starts.

Get rid of all of this excessive casting.  Tell the compiler what you're
actually doing, pass 'desc' in as "void *" and use local "u64 *" pointers
(to which 'desc' is assigned to) if you must.
