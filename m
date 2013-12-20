Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3LTLve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:51:34 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43138 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3LTLvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:51:33 -0500
Message-ID: <52B42F43.7040606@gmail.com>
Date: Fri, 20 Dec 2013 19:51:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: rostedt@goodmis.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-metag@vger.kernel.org
Subject: Re: [PATCH] arch: metag: lib: add "umoddi3.S" file for __umoddi3()
References: <52B2E0FA.7090805@gmail.com> <52B2E3DB.7010008@imgtec.com> <52B2F6B7.1050802@gmail.com> <52B2F8DC.8060006@imgtec.com> <52B3A0EA.9010801@gmail.com> <52B40E44.9040603@imgtec.com> <52B419DE.8050706@gmail.com> <52B4208B.1080801@imgtec.com>
In-Reply-To: <52B4208B.1080801@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 06:48 PM, James Hogan wrote:
> On 20/12/13 10:20, Chen Gang wrote:
>> Hmm... but do you know why we need some 64-bit functions which are
>> implemented under "arch/metag/lib/*.S"? can we use <linux/math64.h>
>> instead of them? (e.g 64-bit '/').
> 
> If you look at linux/math64.h you'll see it only implements division
> operations. The other 64 bit operations like shift, compare, and
> multiply are relatively cheap so are implemented as intrinsics instead.
> 

OK, thanks. tomorrow, I will send related patch: use 'div64_u64_rem'
instead of umoddi3 ('%').  :-)

And I guess, in kernel wide, we need remove all 'umoddi3' and 'udivdi3'.

  umoddi3 ('%'): frv, ia64, parisc, tile, xtensa
  udivdi3 ('/'): frv, ia64, parisc, tile, xtensa, sh, sparc.
  especially, sh and sparc only provide '/', do not provide '%'.


BTW: originally, I make a mistake -- treat 'udevsi3' as 'udevdi3'.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
