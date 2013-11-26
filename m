Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3KZHP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:15:57 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:39133 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3KZHP4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 26 Nov 2013 02:15:56 -0500
Message-Id: <529458B50200007800106F76@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 26 Nov 2013 07:15:49 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <davem@davemloft.net>, <adobriyan@gmail.com>, <d.hatayama@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: also fix proc_reg_get_unmapped_area() for
 !MMU case
References: <529387570200007800106C9F@nat28.tlf.novell.com>
 <20131125141328.d9da16e10526e2ff1d368f0f@linux-foundation.org>
In-Reply-To: <20131125141328.d9da16e10526e2ff1d368f0f@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.11.13 at 23:13, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 25 Nov 2013 16:22:31 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> Commit fad1a86e ("procfs: call default get_unmapped_area on MMU-present
>> architectures"), as its title says, took care of only the MMU case,
>> leaving the !MMU side still in the regressed state (returning -EIO in
>> all cases where pde->proc_fops->get_unmapped_area is NULL).
> 
> The changelog is rather mystifying unless the reader goes off and finds
> the fad1a86e changelog, so let's do that for them by adding this:
> 
> From the fad1a86e changelog:
> 
> : Commit c4fe24485729 ("sparc: fix PCI device proc file mmap(2)") added
> : proc_reg_get_unmapped_area in proc_reg_file_ops and
> : proc_reg_file_ops_no_compat, by which now mmap always returns EIO if
> : get_unmapped_area method is not defined for the target procfs file, which
> : causes regression of mmap on /proc/vmcore.
> : 
> : To address this issue, like get_unmapped_area(), call default
> : current->mm->get_unmapped_area on MMU-present architectures if
> : pde->proc_fops->get_unmapped_area, i.e.  the one in actual file operation
> : in the procfs file, is not defined.
> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Cc: David S. Miller <davem@davemloft.net> 
> 
> I tagged this with
> 
> 	Cc: <stable@vger.kernel.org>	[3.12.x]
> 
> OK?

Sure. I also see you didn't like the way I coded it, and put a
code restructuring patch on top...

Jan

