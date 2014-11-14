Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaKNFJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:09:47 -0500
Received: from karr.yath.de ([144.76.4.50]:57337 "EHLO karr.yath.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaKNFJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:09:46 -0500
Date: Thu, 13 Nov 2014 21:09:34 -0800
From: Sebastian Schmidt <yath@yath.de>
To: Kees Cook <keescook@chromium.org>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Subject: Re: randconfig build error with next-20141113, in fs/pstore/inode.c
Message-ID: <20141114050934.GA7964@moniac.lan.yath.de>
References: <CA+r1ZhjO=kxcyjRb3=d7ozZ_VT9a+iCUy27zPZ2WGVMMzP6OVA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CD43@ORSMSX114.amr.corp.intel.com>
 <CAGXu5jLsd3G3+PCwFSUGDxxbfnJwx8G8X4chH0WK21-kv+_ecA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLsd3G3+PCwFSUGDxxbfnJwx8G8X4chH0WK21-kv+_ecA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, Nov 13, 2014 at 11:21:18AM -0800, Kees Cook wrote:
> > This looks to come from your "Honor dmesg_restrict sysctl on dmesg dumps" patch

Oops, you are right.

> > The randconfig doesn't have CONFIG_PRINTK.  I guess we need to provide a stub
> > in <linux/syslog.h> to cover this.
> 
> Without CONFIG_PRINTK, check_syslog_permissions should probably fail.

Kees, I disagree. Without CONFIG_PRINTK, there isn't even a
dmesg_restrict sysctl, so there is no way to turn that on (AFAICS) and
we should retain the default behaviour.

I'll send a patch shortly.

Sebastian
