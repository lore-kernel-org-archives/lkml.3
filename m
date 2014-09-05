Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaIEW1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaIEW1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:27:53 -0400
Date: Sat, 6 Sep 2014 06:27:41 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, mingo@redhat.com,
        whissi@whissi.de, dyoung@redhat.com, tglx@linutronix.de,
        vgoyal@redhat.com, chaowang@redhat.com
Subject: Re: [PATCH 3/4] kaslr setup_data handling
Message-ID: <20140905222741.GB1675@dhcp-17-102.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-4-git-send-email-bhe@redhat.com>
 <20140905173256.GV5598@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905173256.GV5598@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 at 10:32am, Kees Cook wrote:
> On Fri, Sep 05, 2014 at 10:08:16PM +0800, Baoquan He wrote:
> > From: Dave Young <dyoung@redhat.com>
> > 
> > X86 will pass setup_data region while necessary, these regions could be
> > overwitten by kernel due to kaslr.
> > 
> > Thus iterate and add setup regions to mem_avoid[] in this patch.
> > Up to now there isn't a official data to state the maximal entries
> > setup data could use. So just set max mem avoid entries 32, hopefully
> > it will be enough. This can be increased later when people report
> > they are using more setup data entries.
> 
> Ew, yes, this is bad. I hadn't seen setup_data while designing the
> mem_avoid stuff. I don't like the fixed 32 entry size here, so let me
> consider some options. I think the mem_avoid logic can just walk the
> setup_data list itself, since that's what it's for. :)

Yes, maybe you are right. But it's hard to say what's the max. I guess
1024 could be enough, after all e820MAX is 128. If people don't think
that eat too much stack.

> 
> Does only kexec use this? I assume other boot loaders must be using this
> too. Is there an easy test case for validating this is fixed?

I don't think only kexec use this. If e820 is not enough, extending the
memory region to setup data is designed for all bootloaders. Kernel will
check memory regions from setup data. 

I can't find a machine with so many memory regions. Dave told me one
person has this kind of machine, will ask him to help test if possible.

About test case, if that machine with many memory regions could put
setup data in 1G, that's very easy to test. Not sure of that.

> 
