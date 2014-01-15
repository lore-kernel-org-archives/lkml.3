Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaAORr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaAORrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:47:55 -0500
Date: Wed, 15 Jan 2014 12:47:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, hpa@linux.intel.com,
        jingbai.ma@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: Re: [RESEND PATCH v10] x86, apic, kexec, Documentation: Add
 disable_cpu_apicid kernel parameter
Message-ID: <20140115174714.GG3180@redhat.com>
References: <20140115064458.1545.38775.stgit@localhost6.localdomain6>
 <20140115170525.GF3180@redhat.com>
 <52D6C4B6.8010804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D6C4B6.8010804@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 09:26:14AM -0800, H. Peter Anvin wrote:
> On 01/15/2014 09:05 AM, Vivek Goyal wrote:
> > 
> > I think this is a reasonable approach to solve the issue. Use a command
> > line to not bring up specific cpu in second kernel which can create
> > problems.
> > 
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > 
> > hpa, I know you are not excited about this approach. If you made up your
> > mind that this appoarch is not worth pursuing, please do suggest what
> > would you like to see and we can give that a try.
> > 
> > We want to solve this problem as on large memory machines saving dump can
> > take lot of time and we want to bring up multiple cpus and speed up
> > compression and save on dump time.
> > 
> 
> I'm not excited about kdump's reliance on the command line, since it
> seems to be a neverending source of trouble, simply because the command
> line is fundamentally intended as a human interface.

So in general, what are the alternatives? Either we figure out that kernel
is booting as kdump kernel and do things differently. That seems even
worse as what do we want in kdump kernel will change over a period of
time.

Other thing is that pass more information in bootparams. But that does
not seem much different than command line to me.

>  However, this
> seems relatively harmless in comparison with everything else and I am
> much happier with saving the ID in the first kernel rather than trying
> to guess if a currently-downed CPU is the BSP.

So looks like you are alright with this patch. Can you please queue it
up in your tree.

Thanks
Vivek
