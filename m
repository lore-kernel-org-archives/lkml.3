Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaAaQ57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:57:59 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46576 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaAaQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:57:58 -0500
Message-ID: <52EBD613.3040902@gmail.com>
Date: Fri, 31 Jan 2014 11:57:55 -0500
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: for.poige+linux@gmail.com, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: That greedy Linux VM cache
References: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com> <CA+sTkh4p10P_BbxEx0vxS9uF0zA9G97K+4B_Q1Np55Ui83LVDQ@mail.gmail.com>
In-Reply-To: <CA+sTkh4p10P_BbxEx0vxS9uF0zA9G97K+4B_Q1Np55Ui83LVDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/31/2014 09:47 AM, Igor Podlesny wrote:
> On 31 January 2014 00:58, Igor Podlesny <for.poige+linux@gmail.com> wrote:
> [...]
>>  While I'm thinking about moving system back to XFS...
> 
>    Well, it helped just a bit. The whole picture remains, so it's not
> Btrfs' issue, but seemingly Linux VM's one. The problem can be briefly
> described as "if allowed to swap (swappiness != 0), VM would rather
> start swapping, than reduce cache size which holds ~ 25 % of RAM".
> Even more briefly it's stated in the Subject.
> 
>    From user's point of view, it looks like the system is being
> heavily swapped (and can be easily misinterpreted as it), but actually
> the most disk activity is permanent _reading_ from filesystem, and not
> accessing swap device.
> 
>    Should I fill in a bug report in kernel's bugzilla, or just upgrade
> the notebook? )
> 
If I remember correctly, there is a sysctl for configuring how
aggressively the system tries to retain the VFS cache, changing the
value there might improve things for you.
