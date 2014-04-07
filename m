Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaDGNqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:46:16 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51885 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGNqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <1396834881.11513.41.camel@deadeye.wl.decadent.org.uk>
References: <lsq.1396827348.486893332@decadent.org.uk> <1396834881.11513.41.camel@deadeye.wl.decadent.org.uk>
From: Raphael Geissert <geissert@debian.org>
Date: Mon, 7 Apr 2014 15:45:51 +0200
X-Google-Sender-Auth: Csz0SputLN0Pn7_1-e9a3vmC-JM
Message-ID: <CAA7hUgEiAtb_R3_ODpXVgVSVoQvREChjPCL6GyyVTF8VXiYNyg@mail.gmail.com>
Subject: Re: [PATCH 3.2 17/18] cifs: ensure that uncached writes handle
 unmapped areas correctly
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Shilovsky <piastry@etersoft.ru>, 741958@bugs.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7 April 2014 03:41, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, 2014-04-07 at 00:35 +0100, Ben Hutchings wrote:
>> 3.2.57-rc1 review patch.  If anyone has any objections, please let me know.
> [...]
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
[...]
> +               /*
> +                * i + 1 now represents the number of pages we actually used in
> +                * the copy phase above.
> +                */
> +               npages = min(npages, i + 1);

I'm having trouble understanding why min() is needed here. It
shouldn't harm either, but I find it confusing.

Cheers,
-- 
Raphael Geissert - Debian Developer
www.debian.org - get.debian.net
