Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3EGBoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:44:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13669 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab3EGBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:43:59 -0400
Message-ID: <51885C4D.3010607@huawei.com>
Date: Tue, 7 May 2013 09:43:41 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Wengmeiling <wengmeiling.weng@huawei.com>,
        Libo Chen <libo.chen@huawei.com>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: bcdedcc1afd6 breaks search in menuconfig
References: <20130506154903.GD22041@pd.tnic>
In-Reply-To: <20130506154903.GD22041@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/6 23:49, Borislav Petkov wrote:
> When I do
> 
> make menuconfig
> 
> then press '/' in order to search for a symbol, and I type 'EFI', for
> example, and press enter, I get:
> 
>  │  Enter CONFIG_ (sub)string to search for (with or without "CONFIG_")    │  
>  │ ┌─────────────────────────────────────────────────────────────────────┐ │  
>  │ │EFImake[1]: *** [menuconfig] Segmentation fault                      │ │  
>  │ └───────────────────────────────────────────────make: *** [menuconfig] Error 2
> 
> and the terminal is left in an inconsistent state which I need to
> 'reset'. But, more importantly, the search is b0rked now.
> 

Add a "if (prop)" will fix it.

I'll prepare a patch.

> Reverting the above commit fixes the issue.
> 

