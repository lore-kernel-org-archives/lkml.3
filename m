Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaGOU7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:59:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaGOU7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:59:33 -0400
Date: Tue, 15 Jul 2014 13:59:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 1/1] fs/ubifs/super.c: replace seq_printf by seq_puts
Message-Id: <20140715135932.879df4f901ac58338d387a35@linux-foundation.org>
In-Reply-To: <CAFLxGvyaye+hKGv5L9ZuZAwZNb7FaVpg_n-abSGAmPu+YDc+hQ@mail.gmail.com>
References: <1405452395-9296-1-git-send-email-fabf@skynet.be>
	<CAFLxGvyaye+hKGv5L9ZuZAwZNb7FaVpg_n-abSGAmPu+YDc+hQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 22:10:24 +0200 Richard Weinberger <richard.weinberger@gmail.com> wrote:

> On Tue, Jul 15, 2014 at 9:26 PM, Fabian Frederick <fabf@skynet.be> wrote:
> > Fix checkpatch warnings:
> > "WARNING: Prefer seq_puts to seq_printf"
> 
> Can you explain why seq_puts() is preferred over seq_printf()?

- puts is presumably faster

- puts doesn't go rogue if you accidentally pass it a "%".

- this patch actually made fs/ubifs/super.o 12 bytes smaller. 
  Perhaps because seq_printf() is a varargs function, forcing the
  caller to pass args on the stack instead of in registers.
