Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaFMMuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaFMMuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:50:19 -0400
Date: Fri, 13 Jun 2014 08:49:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140613124939.GD5871@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613080028.GK15034@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613080028.GK15034@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:00:28PM +0800, WANG Chao wrote:
> On 06/13/14 at 09:50am, Borislav Petkov wrote:
> > On Mon, Jun 09, 2014 at 11:41:37AM -0400, Vivek Goyal wrote:
> > > IIUC, COMMAND_LINE_SIZE gives max limits of running kernel and it does
> > > not tell us anything about command line size supported by kernel being
> > > loaded.
> > 
> > Whatever you do, you do need a sane default because even querying the
> > boot protocol is not reliable as the to-be-loaded kernel's boot protocol
> > might be manipulated too, before signing (who knows what people do
> > in the wild).
> 
> Make sense.
> 
> > 
> > So having a sane, unconditional fallback COMMAND_LINE_SIZE from the
> > first kernel is a must, methinks.
> 
> By greping for COMMAND_LINE_SIZE for different arch, I think 8K being
> the fallback, in general, is good for now and the future:

How do you know we will never cross 8K. Also what kind of protection you
have against kernel file size and initrd file size? If we don't have any
protection there, why command line size is so special (Which is much
smaller than kernel and initrd).

Thanks
Vivek
