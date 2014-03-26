Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaCZAmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:42:03 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56814 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaCZAmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:42:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140325211229.GA27422@quack.suse.cz>
References: <20140305124536.GA32371@quack.suse.cz>
	<53189BF8.1010308@oracle.com>
	<531A7CFD.9030603@oracle.com>
	<20140310104350.GB28797@quack.suse.cz>
	<531DC89A.9010601@oracle.com>
	<53304451.7030800@oracle.com>
	<20140324214851.GB10057@quack.suse.cz>
	<5330D15E.2000702@oracle.com>
	<20140325173340.GB17292@quack.suse.cz>
	<5331C20F.5010109@oracle.com>
	<20140325211229.GA27422@quack.suse.cz>
Date: Tue, 25 Mar 2014 17:41:59 -0700
X-Google-Sender-Auth: v5RLhQdmrFuyySwICVwDA7LchSQ
Message-ID: <CA+55aFx_ejUs5Qp7_316hF_X2vyz5Csssz7zyEiHQr2TqH_vyA@mail.gmail.com>
Subject: Re: fs: gpf in simple_setattr
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 2:12 PM, Jan Kara <jack@suse.cz> wrote:
>
>   Can you try whether the following patch fixes the issue for you?

Good catch, Honza.

I hate how fragile that code ends up being and would love to see that
"anon_inode_inode" allocation and assignment just once in
anon_inode_init(), but considering that it wants the superblock
pointer, I suspect it's not cleanly doable. Oh well. Your patch looks
like it should make the issue moot, I just dread this happening again
due to the layout of the code.

Will apply the patch,

             Linus
