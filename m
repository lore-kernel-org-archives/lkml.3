Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3AVNna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:43:30 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:58871 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3AVNn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:43:28 -0500
MIME-Version: 1.0
In-Reply-To: <3544.1358774694@turing-police.cc.vt.edu>
References: <3544.1358774694@turing-police.cc.vt.edu>
Date: Tue, 22 Jan 2013 21:43:27 +0800
Message-ID: <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
Subject: Re: next-20130117 - kernel BUG with aio
From: Hillf Danton <dhillf@gmail.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 9:24 PM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> Am seeing a reproducible BUG in the kernel with next-20130117
> whenever I fire up VirtualBox.  Unfortunately, I hadn't done that
> in a while, so the last 'known good' kernel was next-20121203.
>
> I'm strongly suspecting one of Kent Overstreet's 32 patches against aio,
> because 'git blame' shows those landing on Jan 12, and not much else
> happening to fs/aio.c in ages.
>
Take a try?
---
--- a/fs/aio.c	Tue Jan 22 21:37:54 2013
+++ b/fs/aio.c	Tue Jan 22 21:43:58 2013
@@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(st
 {
 	struct aio_ring *ring;

+	if (!ctx)
+		return;
+
 	smp_wmb();
 	/* make event visible before updating tail */

--
