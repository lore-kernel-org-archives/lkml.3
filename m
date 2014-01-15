Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaAOKb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:31:57 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65071 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAOKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:31:53 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D66396.5050104@roeck-us.net>
Date: Wed, 15 Jan 2014 02:31:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-mm@kvack.org, linux-bcache@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL
References: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 01:33 AM, Geert Uytterhoeven wrote:
> {,set}page_address() are macros if WANT_PAGE_VIRTUAL.
> If !WANT_PAGE_VIRTUAL, they're plain C functions.
>
> If someone calls them with a void *, this pointer is auto-converted to
> struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
> architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc):
>
> drivers/md/bcache/bset.c: In function ‘__btree_sort’:
> drivers/md/bcache/bset.c:1190: warning: dereferencing ‘void *’ pointer
> drivers/md/bcache/bset.c:1190: error: request for member ‘virtual’ in something not a structure or union
>
> Convert them to static inline functions to fix this. There are already
> plenty of  users of struct page members inside <linux/mm.h>, so there's no
> reason to keep them as macros.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

That also fixes the problem seen in stable-queue for 3.10 and 3.12,
so it may be a better fix for the problem seen there than the patch
provided by Michael.

Guenter

