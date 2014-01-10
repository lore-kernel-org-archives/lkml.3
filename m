Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbaAJQCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:02:17 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:6989 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbaAJQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:02:14 -0500
Message-ID: <1389369377.1792.160.camel@misato.fc.hp.com>
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
From: Toshi Kani <toshi.kani@hp.com>
To: Baoquan <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, linux-acpi@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, dyoung@redhat.com
Date: Fri, 10 Jan 2014 08:56:17 -0700
In-Reply-To: <20140110071124.GA6464@dhcp-16-105.nay.redhat.com>
References: <8500545.JVNPnKcyD1@vostro.rjw.lan>
	 <1389226308.1792.39.camel@misato.fc.hp.com>
	 <20140109145035.GB25897@redhat.com>
	 <1389283439.1792.66.camel@misato.fc.hp.com>
	 <20140109162427.GF25897@redhat.com>
	 <1389288265.1792.108.camel@misato.fc.hp.com>
	 <20140109182310.GG25897@redhat.com>
	 <1389292470.1792.109.camel@misato.fc.hp.com>
	 <20140109212705.GC12111@redhat.com>
	 <1389304583.1792.139.camel@misato.fc.hp.com>
	 <20140110071124.GA6464@dhcp-16-105.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 15:11 +0800, Baoquan wrote:
> On 01/09/14 at 02:56pm, Toshi Kani wrote:
 :
> > I am more curious to know how makedumpfile decides what memory ranges to
> > dump.  The 1st kernel may have performed memory hot-add / delete
> > operations before a crash, so it needs to know the valid physical
> > address range at the time of crash, and may not rely on the E820 map
> > from BIOS (which is stale).  Am I right to assume that makedumpfile gets
> > it from the page tables of the 1st kernel?
> 
> makedumpfile just do the dump, what memory ranges to dump is decided in
> 1st kernel by kexec-tools. In 1st kernel, if kexec-tools executed, it
> will find all System Ram memorys which exclude the reserved regions for
> kdump kernel, then build a logical elf file, each load segment is one of
> these System Ram memory regions, its addr and length is written into the
> program header.
> 
> Then makedumpfile just read this elf file, and read all of them and
> dump.
> 
> If after kexec-tools execution and before crash, a hotplug memory is
> removed, udev will check this and trigger a kdump restart, kexec-tools
> is executed again, System Ram region information are stored. The logical
> file header will be passed to 2nd kernel.

Oh, that's how it works.  Thanks for the explanation!  In case of
hot-delete, ideally, the elf file should be updated after a memory
region is put into off-line, but before it is ejected.  But it is
difficult/vulnerable to coordinate such sequence with user space.  So,
the current scheme sounds good to me.

Thanks,
-Toshi

