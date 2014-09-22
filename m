Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaIVPd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:33:57 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47477 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaIVPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <55E81CB2-AB4B-41E2-88D5-B33F7D8B1DB8@cam.ac.uk>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk>
	<CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com>
	<55E81CB2-AB4B-41E2-88D5-B33F7D8B1DB8@cam.ac.uk>
Date: Mon, 22 Sep 2014 08:33:54 -0700
X-Google-Sender-Auth: m0CECRao61gAYe-1QVGVW7Tokcs
Message-ID: <CA+55aFwAdsJ9EWTx3QvMxs2ReTX19Xvd_s7wc+KQ8qnJjg0WDA@mail.gmail.com>
Subject: Re: [PATCH] Fix nasty 32-bit overflow bug in buffer i/o code.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 8:29 AM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>
> You could do "block & ~(sector_t)(size - 1)" instead of "(sector_t)index << sizebits" if you prefer but not sure that is an improvement!

No, it would be even worse. Something like

  block & ~(sector_t)((size >> 9) - 1)

because block is the sector number (ie 512-byte) and size is in bytes.

           Linus
