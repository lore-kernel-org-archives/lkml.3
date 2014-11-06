Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaKFV71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:59:27 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:51388 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaKFV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:59:25 -0500
Date: Thu, 6 Nov 2014 13:59:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2] mm: slub: fix format mismatches in slab_err()
 callers
In-Reply-To: <1415261817-5283-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1411061359060.1526@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1411051344490.31575@chino.kir.corp.google.com> <1415261817-5283-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1184225831-1415311163=:1526"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1184225831-1415311163=:1526
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 6 Nov 2014, Andrey Ryabinin wrote:

> Adding __printf(3, 4) to slab_err exposed following:
> 
> mm/slub.c: In function ‘check_slab’:
> mm/slub.c:852:4: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘const char *’ [-Wformat=]
>     s->name, page->objects, maxobj);
>     ^
> mm/slub.c:852:4: warning: too many arguments for format [-Wformat-extra-args]
> mm/slub.c:857:4: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘const char *’ [-Wformat=]
>     s->name, page->inuse, page->objects);
>     ^
> mm/slub.c:857:4: warning: too many arguments for format [-Wformat-extra-args]
> 
> mm/slub.c: In function ‘on_freelist’:
> mm/slub.c:905:4: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘long unsigned int’ [-Wformat=]
>     "should be %d", page->objects, max_objects);
> 
> Fix first two warnings by removing redundant s->name.
> Fix the last by changing type of max_object from unsigned long to int.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1184225831-1415311163=:1526--
