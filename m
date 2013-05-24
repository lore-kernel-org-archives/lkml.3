Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3EXQrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:47:00 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:35627 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3EXQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:46:59 -0400
Date: Fri, 24 May 2013 18:46:53 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130524184653.52d75b5f@holzheu>
In-Reply-To: <20130524152849.GF18218@redhat.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130524143644.GD18218@redhat.com>
	<20130524170626.2ac06efe@holzheu>
	<20130524152849.GF18218@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052416-0342-0000-0000-00000521053D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 11:28:49 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, May 24, 2013 at 05:06:26PM +0200, Michael Holzheu wrote:

[snip] 

> As /proc/vmcore is the most used and useful interface, I prefer that
> we swap memory and put that info in elf headers. For /dev/oldme, I
> don't mind if we leave it as it is. If somebody really cares, then
> I guess we need to write a new command line option which /dev/mem
> can parse and which tells it about swaps so that /dev/oldmem can
> map things correctly. (This is better than hardcoding things).

Besides of the potential /dev/oldmem issue, I still do not understand
the option of doing the swap in the elf header. Looks like I missed
here a fundamental design point of kdump :(

Is that done by specifying different virtual and physical addresses in
the ELF header?

Michael


