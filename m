Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3DOCGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:06:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42938 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754263Ab3DOCGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:06:19 -0400
Message-ID: <1365991579.1878.26.camel@joe-AO722>
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
From: Joe Perches <joe@perches.com>
To: htl10@users.sourceforge.net
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Apr 2013 19:06:19 -0700
In-Reply-To: <1365990973.28177.YahooMailClassic@web172303.mail.ir2.yahoo.com>
References: <1365990973.28177.YahooMailClassic@web172303.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 02:56 +0100, Hin-Tak Leung wrote:
> --- On Mon, 15/4/13, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2013-04-15 at 01:53 +0100,
> > Hin-Tak Leung wrote:
> > > --- On Mon, 8/4/13, Joe Perches <joe@perches.com> wrote:
> > > > Use a more current logging style.
> > []
> > > I have been sitting on a patch which changes this part
> > of the code to dynamic debugging, and it is much simplier.
[]
> > This change wouldn't work well as it would make a mess
> > of output that uses no prefix (ie: emits at KERN_DEFAULT)
> > with output that uses KERN_DEBUG
> > 
> > That's the reason for _dbg and _dbg_cont.
> 
> Hmm, I don't get it. Is there any *existing* use of dprint
> in the hfplus code which is affected by your comment?

Code like this prints out currently on a single line at
KERN_DEFAULT.

@@ -138,16 +138,16 @@ void hfs_bnode_dump(struct hfs_bnode *node)
[]
        for (i = be16_to_cpu(desc.num_recs); i >= 0; off -= 2, i--) {
                key_off = hfs_bnode_read_u16(node, off);
-               dprint(DBG_BNODE_MOD, " %d", key_off);
+               hfs_dbg_cont(BNODE_MOD, " %d", key_off);

By converting this dprint() to pr_debug(), it would
print out on a multiple lines, one for each read.

That's why it should use a mechanism like dbg_cont.

btw: there is no current pr_debug_cont mechanism.


