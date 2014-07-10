Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaGJS5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:57:10 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:48613 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGJS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140710184416.GE5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<20140710164151.GA5603@pd.tnic>
	<CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
	<20140710184416.GE5603@pd.tnic>
Date: Thu, 10 Jul 2014 11:57:06 -0700
Message-ID: <CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:44 AM, Borislav Petkov <bp@alien8.de> wrote:
>         if (atomic_dec_and_test(&mce_banks[i].poll))
>                 m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
>
>         atomic_add_unless(&mce_banks[i].poll, 1, 1);
>
> so that you have only one CPU read the status register of mce_banks[i].
>
> For non-shared banks, this will always work because no other CPU will
> dec that variable anyway.

You don't know if the bank is shared or not.  If it is not shared, then the
above code might skip reading the bank because some other cpu is busy
reading that bank number - and seeing its own private bank.

-Tony
