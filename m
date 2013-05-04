Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989Ab3EDSDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:03:34 -0400
Received: from stator.leun.net ([85.214.203.199]:46345 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761777Ab3EDSDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:03:32 -0400
Date: Sat, 4 May 2013 20:02:40 +0200
From: Michael Leun <lkml20130126@newton.leun.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [REGRESSION] bisected: 3.8 -> 3.9 cannot umount after using
 fuse
Message-ID: <20130504200240.10a8bae0@xenia.leun.net>
In-Reply-To: <20130504155214.GD25399@ZenIV.linux.org.uk>
References: <20130504124519.032ac684@xenia.leun.net>
	<20130504155214.GD25399@ZenIV.linux.org.uk>
Organization: Not Organized
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 May 2013 16:52:14 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, May 04, 2013 at 12:45:19PM +0200, Michael Leun wrote:
> 
> > After reverting 57eccb830f1cc93d4b506ba306d8dfa685e0c88f from 3.9
> > that umount above works (not busy).
> 
> Sigh...  Check if the following fix works for your testcase:
> diff --git a/fs/namespace.c b/fs/namespace.c
> index b4f96a5..b68eef2d 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[...]

Yup, that fixes it.

-- 
MfG,

Michael Leun

