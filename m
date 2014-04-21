Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaDUQGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:06:09 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:40018 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaDUQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:06:08 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4xBpp54gShxcz4UZpp5X0IKitUVKzTXYq+eMNM=
X-RZG-CLASS-ID: mo05
Message-ID: <535541DA.8040601@samba.org>
Date: Mon, 21 Apr 2014 18:05:46 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
X-Enigmail-Version: 1.5.2
OpenPGP: id=0E53083F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.04.2014 15:45, schrieb Jeff Layton:
> File-private locks have been merged into Linux for v3.15, and *now*
> people are commenting that the name and macro definitions for the new
> file-private locks suck.
> 
> ...and I can't even disagree. The names and command macros do suck.
> 
> We're going to have to live with these for a long time, so it's
> important that we be happy with the names before we're stuck with them.
> 
> The consensus on the lists so far is that they should be rechristened as
> "file-description locks".
> 
> This patch makes the following changes that I think are necessary before
> v3.15 ships:
> 
> 1) rename the command macros to their new names. These end up in the uapi
>    headers and so are part of the external-facing API. It turns out that
>    glibc doesn't actually use the fcntl.h uapi header, but it's hard to
>    be sure that something else won't. Changing it now is safest.
> 
> 2) make the the /proc/locks output display these as type "FDLOCK"
> 
> The rest of the renaming can wait until v3.16, since everything else
> isn't visible outside of the kernel.
> 
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Reviewed-by: Stefan Metzmacher <metze@samba.org>
