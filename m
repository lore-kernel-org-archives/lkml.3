Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaJQPmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:42:13 -0400
Received: from mail.efficios.com ([78.47.125.74]:48278 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaJQPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:42:11 -0400
Date: Fri, 17 Oct 2014 15:42:02 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Message-ID: <2128367244.10915.1413560522748.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141016221624.GL11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <1411677218-29146-21-git-send-email-matthew.r.wilcox@intel.com> <20141016125625.GR19075@thinkos.etherlink> <20141016221624.GL11522@wil.cx>
Subject: Re: [PATCH v11 20/21] ext4: Add DAX functionality
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.156.150.204]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: ext4: Add DAX functionality
Thread-Index: utFX89Rn035yAfbmBn9ZHH/SEVBHBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
> linux-kernel@vger.kernel.org, "Ross Zwisler" <ross.zwisler@linux.intel.com>
> Sent: Friday, October 17, 2014 12:16:24 AM
> Subject: Re: [PATCH v11 20/21] ext4: Add DAX functionality
> 
[...]
> On Thu, Oct 16, 2014 at 02:56:25PM +0200, Mathieu Desnoyers wrote:
> > > @@ -3572,6 +3579,11 @@ static int ext4_fill_super(struct super_block *sb,
> > > void *data, int silent)
> > >  				 "both data=journal and dioread_nolock");
> > >  			goto failed_mount;
> > >  		}
> > > +		if (test_opt(sb, DAX)) {
> > > +			ext4_msg(sb, KERN_ERR, "can't mount with "
> > > +				 "both data=journal and dax");
> > 
> > This limitation regarding ext4 and dax should be documented in dax
> > Documentation.
> 
> Maybe the ext4 documentation too?  It seems kind of obvious to me that if
> ypu're enabling in-place-updates that you can't journal the data you're
> updating (well ... you could implement undo-log journalling, I suppose,
> which would be quite a change for ext4)

Yes, we could document this limitation in general for all journalling FS within
DAX documentation, and then document it specifically per-FS in the FS
documentation.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
