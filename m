Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab3B0PMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:12:06 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:39989 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758160Ab3B0PME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:12:04 -0500
Message-ID: <512E2241.9040705@mimc.co.uk>
Date: Wed, 27 Feb 2013 15:12:01 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: JFFS2 corruption
References: <512CD9BA.3080300@mimc.co.uk> <20130227101824.6e18ba21fb99070594420f29@canb.auug.org.au>
In-Reply-To: <20130227101824.6e18ba21fb99070594420f29@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/13 23:18, Stephen Rothwell wrote:
> Hi Mark,
> 
> On Tue, 26 Feb 2013 15:50:18 +0000 Mark Jackson <mpfj-list@mimc.co.uk> wrote:
>>
>> Just tested the current next-20130226 on a custom AM335X board, and if I mount
>> our JFFS2 image as read/write, the next reboot shows the image as being corrupt.
>>
>> If I reprogram the jffs2 image into NAND and only mount the volume as read-only,
>> no corruption occurs and the system remains intact.
>>
>> I have also tested:-
>>
>> (a) reprogram ubifs image into nand
>> (b) boot the volume as read-only (corrupt -> no)
>> (c) remount the volume as read/write
>> (d) rebooting the volume as read-only (corrupt -> yes)
> 
> Thanks for all the testing.  Sam questions as in my other email.

Okay, just tested 3v8 plus:-

https://patchwork.kernel.org/patch/1931251/
https://patchwork.kernel.org/patch/1931221/
https://patchwork.kernel.org/patch/1931201/
and changed drivers/mtd/nand/elm.c, line 388 "ti,am33xx-elm" to "ti,am3352-elm"

This produces an identical corruption.

I have also tested next-20130225 and next-20130227, and both cause the same corruption.

Regards
Mark J.
