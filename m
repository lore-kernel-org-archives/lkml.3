Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaBEQuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:50:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaBEQuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:50:00 -0500
Date: Wed, 5 Feb 2014 11:49:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Message-ID: <20140205164952.GH6042@redhat.com>
References: <1391556352-15881-1-git-send-email-greg.pearson@hp.com>
 <20140205133912.GC6042@redhat.com>
 <52F26928.4050101@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F26928.4050101@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 04:39:05PM +0000, Pearson, Greg wrote:
> On 02/05/2014 06:39 AM, Vivek Goyal wrote:
> > On Tue, Feb 04, 2014 at 04:25:52PM -0700, Greg Pearson wrote:
> >
> > [..]
> >> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> >> index 2ca7ba0..88d4585 100644
> >> --- a/fs/proc/vmcore.c
> >> +++ b/fs/proc/vmcore.c
> >> @@ -468,17 +468,24 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
> >>   			return rc;
> >>   		}
> >>   		nhdr_ptr = notes_section;
> >> -		while (real_sz < max_sz) {
> >> -			if (nhdr_ptr->n_namesz == 0)
> >> -				break;
> >> +		while (nhdr_ptr->n_namesz != 0) {
> >>   			sz = sizeof(Elf64_Nhdr) +
> >>   				((nhdr_ptr->n_namesz + 3) & ~3) +
> >>   				((nhdr_ptr->n_descsz + 3) & ~3);
> >> +			if ((real_sz + sz) > max_sz) {
> >> +				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
> >> +					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
> > You will need line break in pr_warn(). Too long a line. Limit it 80
> > columns per line.
> 
> The checkpatch.pl script issues a warning when you break quoted strings, 
> I have no personal preference. Just let me know if you want me to ignore 
> the checkpatch warning and conform to the 80 column per line limit.

Hmm.., I am reading CodingStyle and it does say that do not break user
visible strings as it breaks ability to grep these. 

"However, never break user-visible strings such as
printk messages, because that breaks the ability to grep for them."

Ok, so I am fine with this patch.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
