Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DILG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:06:29 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48181 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935212Ab3DILGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:06:24 -0400
Message-ID: <1365505580.2482.35.camel@slavad-ubuntu>
Subject: Re: [PATCH 0/2] hfs/hfsplus: Modernize logging styles
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Joe Perches <joe@perches.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 15:06:20 +0400
In-Reply-To: <1365503985.6865.25.camel@joe-AO722>
References: <1365401315.2673.11.camel@slavad-ubuntu>
	 <cover.1365438493.git.joe@perches.com>
	 <1365491284.2482.19.camel@slavad-ubuntu>
	 <1365503985.6865.25.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.127.125 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 03:39 -0700, Joe Perches wrote:
> On Tue, 2013-04-09 at 11:08 +0400, Vyacheslav Dubeyko wrote:
> > On Mon, 2013-04-08 at 09:37 -0700, Joe Perches wrote:
> > > Joe Perches (2):
> > >   hfs/hfsplus: Convert dprint to hfs_dbg
> > >   hfs/hfsplus: Convert printks to pr_<level>
> []
> > But I have some additional suggestions:
> > (1) I think that it makes sense to use no_printk() for the case when we
> > don't need in debug output.
> 
> I don't.
> 
> no_printk is used simply to get gcc to verify
> format and args with __printf().
> 
> The equivalent is already done by the
> 	if (DBG_##FLAG & DBG_MASK)
> 		printk(...)
> when DBG_MASK is 0
> 

Ok. I agree.

> > (2) I think that it is really necessary to add info about file and line
> > number for the case of debug output.
> 
> I don't.  I think file/line is pretty useless.
> 

I don't think so. Namely during debugging the file/line info is very
useful, from my point of view. So, I think that this adding makes sense.

> Adding dynamic_debug could be useful, but that's
> another patch.
> 
> Also, checkpatch can be a useful tool, but all
> its warnings aren't necessary to always be fixed.
> 

As I see, the goal of this patch set is overcome of checkpatch warnings.
I'd prefer not change the style of error messages in HFS/HFS+ drivers.
But this patch set makes sense because it fixes warnings of checkpatch
related to error messages.

Moreover, as I see the most of rest checkpatch's warnings makes sense
and it needs to be fixed, from my point of view.

> Also, please remember to trim your replies.
> It's not necessary to quote the entire email.
> Just quote the useful contextual bits.
> _Lots_ of people read this list and you can
> cause a lot to waste time looking for additional
> comments you don't make.

Sorry. It's my mistake.

With the best regards,
Vyacheslav Dubeyko.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


