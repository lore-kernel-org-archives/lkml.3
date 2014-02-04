Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaBDRCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:02:52 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64694 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBDRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:02:49 -0500
MIME-Version: 1.0
In-Reply-To: <1391533134-2234-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1391533134-2234-1-git-send-email-kosaki.motohiro@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 4 Feb 2014 12:02:29 -0500
X-Google-Sender-Auth: i8kCuvuyQPmeJdDoztkEt6LeM8w
Message-ID: <CAHGf_=qdtQsxE3vYcmUgSre=MiTd7ycYSFCeiTGD2z7b+eE36A@mail.gmail.com>
Subject: Re: [PATCH] __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 11:58 AM,  <kosaki.motohiro@gmail.com> wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> To use spin_{un}lock_irq is dangerous if caller disabled interrupt.
> spin_lock_irqsave is a safer alternative. Luckily, now there is no
> caller that has such usage but it would be nice to fix.
>
> Reported-by: David Rientjes rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Self Nack this. There IS a caller and we should send this to stable.
I'll respin.
