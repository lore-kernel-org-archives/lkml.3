Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaGQShi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:37:38 -0400
Received: from mailsec112.isp.belgacom.be ([195.238.20.108]:38576 "EHLO
	mailsec112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbaGQShg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:37:36 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=QtXKAWzsBkcudMCKpZuGZ7NJaqRtyPzs72kSfj+Kyd4= c=1 sm=2
 a=nKpn-3tZ-F4A:10 a=IkcTkHD0fZMA:10 a=Yvs7EeInAAAA:8
 a=KU4zMRCubtXxhNZMp28A:9 a=QEXdDO2ut3YA:10 a=myC0mAPUGvMA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcpAGIXyFPD7hTS/2dsb2JhbABZgw6BKYJ4qiABAQEGnjABgQcWdgQzAQGDSgEBBAEjBFIFCwUGDgoCAhgOAgJXBhMRiCkMrjuGf5AcF4EshE+JHTMHgniBTgWvS4NGOy8
Date: Thu, 17 Jul 2014 20:37:34 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Message-ID: <1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140716172021.GA10833@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be> <20140716172021.GA10833@lenny.home.zabbo.net>
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 16 July 2014 at 19:20 Zach Brown <zab@zabbo.net> wrote:
>
>
> On Tue, Jul 15, 2014 at 09:17:17PM +0200, Fabian Frederick wrote:
> > Fix the following sparse warning:
> > fs/btrfs/send.c:518:51: warning: incorrect type in argument 2 (different
> > address spaces)
> > fs/btrfs/send.c:518:51:    expected char const [noderef] *
> > fs/btrfs/send.c:518:51:    got char *
> >
> > We can safely use (const char __user *) with set_fs(KERNEL_DS)
>
> Yeah, that cast is correct.
>
> Reviewed-by: Zach Brown <zab@zabbo.net>
>
> > @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf,
> > u32 len, loff_t *off)
>
> Though this probably wants to be rewritten in terms of kernel_write().
> That'd give an opportunity to get rid of the sctx->send_off and have it
> use f_pos in the filp.

Do you mean directly call kernel_write from send_cmd/send_header ?
I guess that loop around vfs_write in write_buf is there for something ...

Fabian

>
> - z
