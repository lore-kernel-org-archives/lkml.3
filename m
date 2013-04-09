Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937759Ab3DIKjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:39:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32906 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935228Ab3DIKjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:39:46 -0400
Message-ID: <1365503985.6865.25.camel@joe-AO722>
Subject: Re: [PATCH 0/2] hfs/hfsplus: Modernize logging styles
From: Joe Perches <joe@perches.com>
To: slava@dubeyko.com
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 03:39:45 -0700
In-Reply-To: <1365491284.2482.19.camel@slavad-ubuntu>
References: <1365401315.2673.11.camel@slavad-ubuntu>
	 <cover.1365438493.git.joe@perches.com>
	 <1365491284.2482.19.camel@slavad-ubuntu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 11:08 +0400, Vyacheslav Dubeyko wrote:
> On Mon, 2013-04-08 at 09:37 -0700, Joe Perches wrote:
> > Joe Perches (2):
> >   hfs/hfsplus: Convert dprint to hfs_dbg
> >   hfs/hfsplus: Convert printks to pr_<level>
[]
> But I have some additional suggestions:
> (1) I think that it makes sense to use no_printk() for the case when we
> don't need in debug output.

I don't.

no_printk is used simply to get gcc to verify
format and args with __printf().

The equivalent is already done by the
	if (DBG_##FLAG & DBG_MASK)
		printk(...)
when DBG_MASK is 0

> (2) I think that it is really necessary to add info about file and line
> number for the case of debug output.

I don't.  I think file/line is pretty useless.

Adding dynamic_debug could be useful, but that's
another patch.

Also, checkpatch can be a useful tool, but all
its warnings aren't necessary to always be fixed.

Also, please remember to trim your replies.
It's not necessary to quote the entire email.
Just quote the useful contextual bits.
_Lots_ of people read this list and you can
cause a lot to waste time looking for additional
comments you don't make.

