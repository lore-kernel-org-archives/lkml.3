Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab3FYJJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:09:38 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:53319 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3FYJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:09:34 -0400
Date: Tue, 25 Jun 2013 11:09:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: s390: kernel: reset 'c->hotpluggable' when failure
 occurs
Message-ID: <20130625090928.GA8981@osiris>
References: <51C8F685.6000209@asianux.com>
 <20130625064832.GA4999@osiris>
 <51C94599.1020707@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C94599.1020707@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062509-5024-0000-0000-0000066AC896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:24:09PM +0800, Chen Gang wrote:
> On 06/25/2013 02:48 PM, Heiko Carstens wrote:
> > On Tue, Jun 25, 2013 at 09:46:45AM +0800, Chen Gang wrote:
> >> > When smp_add_present_cpu() fails, it has reset all things excluding
> >> > 'c->hotpluggable', so need reset it as original state completely.
> >> > 
> >> > +	c->hotpluggable = 0;
> >> >  	return rc;
> > No, that doesn't make sense. All cpus on s390 are always hotplugable.
> > It really doesn't matter if the value of this field is 0 or 1 after
> > an error.
> > 
> 
> If so, is it better to set 'c->hotpluggable' for all cpus on s390 during
> initializing ?

No, just leave the code as it is.

