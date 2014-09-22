Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaIVPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:24:50 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50499 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaIVPYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk>
	<CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com>
Date: Mon, 22 Sep 2014 08:24:47 -0700
X-Google-Sender-Auth: jtdkiGrCUwfzeeAgi1MBq6ib2zc
Message-ID: <CA+55aFyXgMO4ADNMSQ81rwSRMkOSFvvig9LA+SJXYuov58HZJw@mail.gmail.com>
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

On Mon, Sep 22, 2014 at 8:18 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ugh. Does the simpler patch to just pass in "block" work as well?

Ugh, never mind, no it does not. It doesn't truncate the sectors to
the beginning of a page boundary.

Will take the patch as-is (will edit the commit message that seems a
bit inaccurate).

             Linus
