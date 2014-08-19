Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaHSLe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:34:27 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52502 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHSLeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:34:25 -0400
Message-ID: <53F3363E.3030601@suse.cz>
Date: Tue, 19 Aug 2014 13:34:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/tty/nozomi.c: Use 'nozomi_setup_memory' instead
 of 'setup_memory'
References: <53E4F332.2080407@gmail.com>
In-Reply-To: <53E4F332.2080407@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014, 05:56 PM, Chen Gang wrote:
> Several architectures (e.g. microblaze, um, and score) have already have
> extern 'setup_memory', so need use 'nozomi_setup_memory' instead of, or
> will cause compiling issue.
> 
> The related error (with allmodconfig for microblaze):
> 
>   CC [M]  drivers/tty/nozomi.o
> drivers/tty/nozomi.c:526:13: error: conflicting types for 'setup_memory'
>  static void setup_memory(struct nozomi *dc)
>              ^
> In file included from include/linux/mm.h:51:0,
>                  from ./arch/microblaze/include/asm/io.h:17,
>                  from include/linux/io.h:22,
>                  from include/linux/pci.h:31,
>                  from drivers/tty/nozomi.c:46:
> ./arch/microblaze/include/asm/pgtable.h:569:6: note: previous declaration of 'setup_memory' was here
>  void setup_memory(void);
>       ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Oh, sure. Thanks.

Acked-by: Jiri Slaby <jslaby@suse.cz>


-- 
js
suse labs
