Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaBCTgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:36:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22135 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaBCTgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:36:39 -0500
Message-ID: <52EFEFFE.6010608@oracle.com>
Date: Mon, 03 Feb 2014 14:37:34 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -v2] x86, microcode, AMD: Sanity-check initrd image
References: <52E81B90.8040604@oracle.com> <20140128213030.GM815@pd.tnic> <52E8230F.7080300@oracle.com> <52E83903.5040908@oracle.com> <20140128232219.GO815@pd.tnic> <20140130151321.GC23342@pd.tnic> <52EAAAD5.2010301@oracle.com> <20140130195413.GH23342@pd.tnic> <20140203175526.GB4281@pd.tnic> <52EFEA57.4000709@oracle.com> <20140203193000.GD4281@pd.tnic>
In-Reply-To: <20140203193000.GD4281@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 02:30 PM, Borislav Petkov wrote:
> On Mon, Feb 03, 2014 at 02:13:27PM -0500, Boris Ostrovsky wrote:
>> I thought that it may be sufficient to check for !container in
>> save_microcode_in_initrd_amd() before performing relocation. If the
>> signature was wrong, we would have found out about it in
>> load_ucode_bsp() -> apply_ucode_in_initrd() and returned right away,
> Your original test case which exploded had exactly that scenario - it
> was pointing to Intel ucode so container wasn't NULL. Thus we need to
> check the sig in find_ucode_in_initrd().
>

It exploded when 'if (!container)' check was done *after* relocation, 
which made container non-zero. If you do the check *before* then I think 
you will catch the fact that container is empty.

load_ucode_bsp() -> apply_ucode_in_initrd() path does not include 
save_microcode_in_initrd_amd() and (if I understand the code correctly) 
we already verify signature in apply_ucode_in_initrd().

I am pretty sure I tested this scenario but I can verify it again.

-boris
