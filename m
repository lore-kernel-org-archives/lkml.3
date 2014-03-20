Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbaCTOc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758862AbaCTOcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:32:47 -0400
Date: Thu, 20 Mar 2014 10:32:07 -0400
From: Dave Jones <davej@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Benjamin <bcrl@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>,
        jmoyer@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] aio: fix the confliction of read events and
 migrating ring page
Message-ID: <20140320143207.GA3760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Gu Zheng <guz.fnst@cn.fujitsu.com>, Benjamin <bcrl@kvack.org>,
	Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
	kosaki.motohiro@jp.fujitsu.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
	tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
	linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <532A80B1.5010002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532A80B1.5010002@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 01:46:25PM +0800, Gu Zheng wrote:

 > diff --git a/fs/aio.c b/fs/aio.c
 > index 88ad40c..e353085 100644
 > --- a/fs/aio.c
 > +++ b/fs/aio.c
 > @@ -319,6 +319,9 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 >  	ctx->ring_pages[old->index] = new;
 >  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 >  
 > +	/* Ensure read event is completed before putting old page */
 > +	mutex_lock(&ctx->ring_lock);
 > +	mutex_unlock(&ctx->ring_lock);
 >  	put_page(old);
 >  
 >  	return rc;

This looks a bit weird. Would using a completion work here ?

	Dave

