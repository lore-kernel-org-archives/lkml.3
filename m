Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaBCRFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaBCRFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:05:41 -0500
Date: Mon, 3 Feb 2014 12:05:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header
 update
Message-ID: <20140203170526.GB10795@redhat.com>
References: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
 <20140131151651.26ff54cd7bd06fc5feb6fcc6@linux-foundation.org>
 <52EC48D0.4000503@hp.com>
 <20140131181254.da3f8e97.akpm@linux-foundation.org>
 <8738k1tane.fsf@xmission.com>
 <20140203154704.GA10795@redhat.com>
 <52EFCA92.3030903@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EFCA92.3030903@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 04:57:56PM +0000, Pearson, Greg wrote:

[..]
> > So I will not be too worried about skipping seemingly corrupted ELf
> > notes. I think giving a warning makes sense though. Is somebody
> > overwriting the memory area in kenrel reserved for per cpu PT_NOTE.
> 
> I haven't figured out the cause of the strange second PT_NOTE entries 
> yet, but I suspect some type of memory corruption.

Hi Greg,

May be put some printk() in crash_save_cpu() and make sure that at
creation time notes are being created properly. That will atleast
make clear whether elf notes were not created properly or they got
corrupted later.

Thanks
Vivek
