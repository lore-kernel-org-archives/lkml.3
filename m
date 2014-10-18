Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaJRPQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:16:07 -0400
Received: from mout.gmx.net ([212.227.15.18]:56978 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaJRPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:16:03 -0400
Message-ID: <54428348.2050209@gmx.at>
Date: Sat, 18 Oct 2014 17:12:08 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>
CC: Daniel Walter <dwalter@google.com>, Randy Dunlap <rdunlap@infradead.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Remove unused bp stack-frame pointer
References: <544277C5.9030302@gmx.at> <54427C48.9050608@nod.at>
In-Reply-To: <54427C48.9050608@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:+qXMtp698MBwKk0ygPHgdVY/3OoOHnpH7wXw7C2ZeCoMwFOURKe
 JBVsMf+VqwtYfRIs8oT/zNaptIx8vwsG9GtqXDvrqfObzEmXtr1BXW6q34vRVJZ2zxHg+ma
 zjQmtaap+XGLz9sN+oNP55wqWxXF1jFGJJVqKdqV1UTcmy1dcx6PGKA3Av5NyBZLO5ijhgG
 kFJ6B0ew+/OpHzmecXQow==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-18 16:42, Richard Weinberger wrote:
> Am 18.10.2014 um 16:23 schrieb Manfred Schlaegl:
>> The pointer to bp stack-frame is no longer used. Removed it.
> 
> Good catch!
Thank you.

> 
>> This also removes a corresponding compiler-warning.
> 
> Which warning exactly?

On "normal" (defconfig) builds the warning does not show up because CONFIG_FRAME_POINTER is set.
I've found the unused bp because CONFIG_FRAME_POINTER was not set in my configuration.

  CC      arch/um/kernel/sysrq.o
arch/um/kernel/sysrq.c: In function ‘show_stack’:
arch/um/kernel/sysrq.c:32:29: warning: unused variable ‘bp’ [-Wunused-variable]

It's reproducible on linus-tree (0429fbc0b) by
make mrproper
make tinyconfig ARCH=um SUBARCH=i386
make ARCH=um SUBARCH=i386

> 
> Thanks,
> //richard
> 
best regards,
manfred
