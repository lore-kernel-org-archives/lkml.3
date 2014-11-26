Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaKZS6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:58:45 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:56750 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKZS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:58:43 -0500
MIME-Version: 1.0
In-Reply-To: <547620E6.10306@oracle.com>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
	<547620E6.10306@oracle.com>
Date: Wed, 26 Nov 2014 10:58:43 -0800
X-Google-Sender-Auth: Zh5Snv7RoSgAXCHT1MzwGDsZyvo
Message-ID: <CA+55aFyiCg23eL=y0nE8a-6_tBAtB097J8v_BtpUcHU8sc3hyQ@mail.gmail.com>
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:50 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> The kernel still has it's share of *signed* integer overflows. Example? fadvise64_64():

Yes, those would definitely be worth fixing.

[ Although quite frankly, since I know gcc already knows about the
whole "check for overflow" pattern, from a QoI standpoint it is sad
that it then might optimize it away. Kind of like how it would trust
the type-based strict alias analysis more than the obvious *static*
alias analysis. Oh well ]

I don't think coccinelle can do signedness checks, though, especially
of the kind that are hidden deep behind some typedef like "loff_t".
Maybe I'm wrong. Maybe smatch can? Adding Dan Carpenter to the cc..

                             Linus
