Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaDYBwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbaDYBw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:52:27 -0400
Date: Fri, 25 Apr 2014 09:53:54 +0800
From: Dave Young <dyoung@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140425015354.GA3224@darkstar.nay.redhat.com>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
 <20140424104540.GA5834@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424104540.GA5834@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/14 at 12:45pm, Ingo Molnar wrote:
> 
> * Dave Young <dyoung@redhat.com> wrote:
> 
> > earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"
> 
> That's a bug.
> 
> > 
> > Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> > Thus efi earlyconsole can not be kept.
> > 
> > So just ignore it and give out a warning to user.
> 
> So, bugs should be fixed, not worked around.
> 
> earlyprintk=,keep is really useful for the occasional difficult low 
> level bug in the printk code or similar, because earlyprintk is a 
> completely separate code path from printk().

I thought that earlyprintk is just for debugging before real console is available.
But it does help debugging printk as you said.

Will think about how to fix it.

Thanks
Dave
