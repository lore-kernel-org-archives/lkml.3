Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbaJ3Onq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:43:46 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35899 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbaJ3Onp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:43:45 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
References: <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
Date: Thu, 30 Oct 2014 15:36:02 +0100
Message-ID: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com>
Subject: Re: [PATCH] Overlayfs: ovl_fill_merge() should use container_of()
 rather than direct cast
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 3:10 PM, David Howells <dhowells@redhat.com> wrote:
> ovl_fill_merge() effectively directly casts the buf pointer to an
> ovl_readdir_data struct pointer, but the pointer actually points to the
> dir_context struct contained therein.
>
> So use container_of() instead.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Okay, but why don't we have a typed argument of actor then?

Being typeless is encouraging exactly the kind of games overlayfs is
doing (probably copied mindlessly from some other part of the kernel).

Thanks,
Miklos
