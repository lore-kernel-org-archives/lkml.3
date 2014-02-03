Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaBCPrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbaBCPrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:47:11 -0500
Date: Mon, 3 Feb 2014 10:47:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header
 update
Message-ID: <20140203154704.GA10795@redhat.com>
References: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
 <20140131151651.26ff54cd7bd06fc5feb6fcc6@linux-foundation.org>
 <52EC48D0.4000503@hp.com>
 <20140131181254.da3f8e97.akpm@linux-foundation.org>
 <8738k1tane.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738k1tane.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 02:25:25PM -0800, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Sat, 1 Feb 2014 01:07:29 +0000 "Pearson, Greg" <greg.pearson@hp.com> wrote:
> >
> >> As far as I know the only consequence of dropping a PT_NOTE entry is 
> >> that it would not be available in the crash dump for use in debugging. 
> >> I'm not sure how important this data might be for triage. I'm guessing 
> >> that in cases where one of these strange PT_NOTE entries shows up with a 
> >> size that causes an overflow it probably isn't even a real PT_NOTE entry 
> >> so dropping it won't matter, but that's a guess at this point since I'm 
> >> still trying to figure out how the bogus entries were created.
> >
> > Can we detect the crazy-huge notes, skip them and then proceed with
> > the following sanely-sized ones?
> 
> The only way we can have following sanely-sized notes is if they are in
> a separate note segment (one of our extensions for kdump and
> /proc/vmcore merges them together).

This processing is happening before we have merged ELF notes. Previous
kernel/kexec-tools prepared per cpu PT_NOTE type ELF note. One for
each cpu. And by default it prepares only one ELF note per PT_NOTE. So
there should not be more notes in the same PT_NOTE.

Also even if there are, n_namesz and n_descsz values seem so high that
after skipping these nothing valid should be after that.

So I will not be too worried about skipping seemingly corrupted ELf
notes. I think giving a warning makes sense though. Is somebody
overwriting the memory area in kenrel reserved for per cpu PT_NOTE.

Thanks
Vivek
