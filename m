Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaC0VeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:34:11 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40672 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993AbaC0VeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140327205749.GM17679@kvack.org>
References: <20140327134653.GA22407@kvack.org>
	<CA+55aFzFgY4-26SO-MsFagzaj9JevkeeT1OJ3pjj-tcjuNCEeQ@mail.gmail.com>
	<CA+55aFx7vg2rvOu6Bu_e8+BB=ymoUMp0AM9JmAuUuSgo0LVEwg@mail.gmail.com>
	<20140327200851.GL17679@kvack.org>
	<CA+55aFy_sRnFu7KguAUAN5kbHk3Qa_0ZuATPU5i8LOyMMWZ_5g@mail.gmail.com>
	<20140327205749.GM17679@kvack.org>
Date: Thu, 27 Mar 2014 14:34:08 -0700
X-Google-Sender-Auth: uJVqtGFVVFqaHkw8riAhhaIgSu0
Message-ID: <CA+55aFyj2XFMkT1T=EPPw1CANt6atyFNmMaeaDm-p-NWfRNA+w@mail.gmail.com>
Subject: Re: git pull -- [PATCH] aio: v2 ensure access to ctx->ring_pages is
 correctly serialised
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, linux-aio@kvack.org,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 1:57 PM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> *nod* -- I added that to the below variant.

You still have "goto err" for cases that have the ctx locked. Which
means that the thing gets free'd while still locked, which causes
problems for lockdep etc, so don't do it.

Do what I did: add a "err_unlock" label, and make anybody after the
mutex_lock() call it. No broken shortcuts.

              Linus
