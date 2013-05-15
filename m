Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3EOUPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:15:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab3EOUPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:15:48 -0400
Date: Wed, 15 May 2013 22:11:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] coredump: format_corename() fixes/cleanups
Message-ID: <20130515201158.GA14606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/13, Oleg Nesterov wrote:
>
> With the patch below we can trivially fix the problem,
>
>       +       char *fmt = ispipe ? "\e%s\e" : "%s";
>       ...
>       -       err = cn_printf(cn, "%s", current->comm);
>       +       err = cn_printf(cn, fmt, current->comm);
>
> Or this ESC hack is too ugly or can break something?

OK, nobody really nacked "[PATCH] teach argv_split() to ignore the spaces
surrounded by \e", see http://marc.info/?l=linux-kernel&m=136845597401674

I am going to send this patch "officially" and fix format_corename/argv_split
interaction.

But lets fix other format_corename() bugs first: leak and use-after-free.
Plus some cleanups.

Oleg.

 fs/coredump.c |  120 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 58 insertions(+), 62 deletions(-)

