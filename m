Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab3BTRzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:55:01 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43237 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933919Ab3BTRy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:54:59 -0500
Message-ID: <1361379050.29360.12.camel@falcor1>
Subject: Re: linux-next: Tree for Feb 19 (security/integrity/ima)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Date: Wed, 20 Feb 2013 11:50:50 -0500
In-Reply-To: <512418A5.9010006@infradead.org>
References: <20130219170309.efb90173fcd879bf32a7e89b@canb.auug.org.au>
	 <512418A5.9010006@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022017-7182-0000-0000-0000055E57B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 16:28 -0800, Randy Dunlap wrote:
> On 02/18/13 22:03, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130218:
> > 
> 
> on x86_64:
> 
>   CC      security/integrity/ima/ima_policy.o
> security/integrity/ima/ima_policy.c: In function 'ima_parse_rule':
> security/integrity/ima/ima_policy.c:538:4: error: implicit declaration of function 'part_pack_uuid' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[4]: *** [security/integrity/ima/ima_policy.o] Error 1
> 
> 
> Full randconfig file is attached.

part_pack_uuid() is only defined for CONFIG_BLOCK in
include/linux/genhd.h.  One solution would be to add a stub function
definition in include/linux/genhd.h, the other option would be to ifndef
CONFIG_BLOCK in C code.

thanks,

Mimi




