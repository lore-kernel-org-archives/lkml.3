Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaBACIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 21:08:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbaBACIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 21:08:41 -0500
Date: Fri, 31 Jan 2014 18:12:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header
 update
Message-Id: <20140131181254.da3f8e97.akpm@linux-foundation.org>
In-Reply-To: <52EC48D0.4000503@hp.com>
References: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
	<20140131151651.26ff54cd7bd06fc5feb6fcc6@linux-foundation.org>
	<52EC48D0.4000503@hp.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014 01:07:29 +0000 "Pearson, Greg" <greg.pearson@hp.com> wrote:

> As far as I know the only consequence of dropping a PT_NOTE entry is 
> that it would not be available in the crash dump for use in debugging. 
> I'm not sure how important this data might be for triage. I'm guessing 
> that in cases where one of these strange PT_NOTE entries shows up with a 
> size that causes an overflow it probably isn't even a real PT_NOTE entry 
> so dropping it won't matter, but that's a guess at this point since I'm 
> still trying to figure out how the bogus entries were created.

Can we detect the crazy-huge notes, skip them and then proceed with
the following sanely-sized ones?

