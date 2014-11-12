Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaKLSrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:47:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43193 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaKLSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:47:13 -0500
Date: Wed, 12 Nov 2014 13:35:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, boris.ostrovsky@oracle.com,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 3/8] xen: Delay m2p_override initialization
Message-ID: <20141112183522.GA2709@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-4-git-send-email-jgross@suse.com>
 <5461E50C.4040309@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5461E50C.4040309@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:29:32AM +0000, David Vrabel wrote:
> On 11/11/14 05:43, Juergen Gross wrote:
> > The m2p overrides are used to be able to find the local pfn for a
> > foreign mfn mapped into the domain. They are used by driver backends
> > having to access frontend data.
> > 
> > As this functionality isn't used in early boot it makes no sense to
> > initialize the m2p override functions very early. It can be done
> > later without doing any harm, removing the need for allocating memory
> > via extend_brk().
> > 
> > While at it make some m2p override functions static as they are only
> > used internally.
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> But...
> 
> >  static struct page *m2p_find_override(unsigned long mfn)
> >  {
> >  	unsigned long flags;
> > -	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
> > +	struct list_head *bucket;
> >  	struct page *p, *ret;
> 
> 
>     if (unlikely(!m2p_overrides))
>         return NULL;
> 
> Would be preferred,

Aye,

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> David
