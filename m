Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3LDRVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:21:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab3LDRVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:21:01 -0500
Date: Wed, 4 Dec 2013 12:20:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: mjg59@srcf.ucam.org, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com
Subject: Re: [PATCH 6/6] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20131204172034.GC19087@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
 <20131128112816.GC4318@dhcp-16-252.nay.redhat.com>
 <20131202153037.GD18642@redhat.com>
 <20131204015127.GC3298@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204015127.GC3298@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:51:27AM +0800, Baoquan He wrote:
> On 12/02/13 at 10:30am, Vivek Goyal wrote:
> > On Thu, Nov 28, 2013 at 07:28:16PM +0800, Baoquan He wrote:
> > 
> > [..]
> > > > +int crash_copy_backup_region(struct kimage *image)
> > > > +{
> > > 
> > > Why need this func be called, backup region has been added into crash
> > > segment by kexec_add_buffer, and then buffer copy is done in
> > > kimage_load_crash_segment. I think this copy is handled twice. Please
> > > correct me if I am wrong.
> > > 
> > 
> > Hi Bao,
> > 
> > kexec_add_buffer() will copy the backup region but it will happen when
> > crash kernel is loaded. We want snapshot of backup region at the time
> > of crash and that's why this second call to copy backup region and it
> > is executed after the crash.
> 
> Did we do this before? And will this region  be changed after 1st kernel
> boot

Backup region is first 640K and it can change after load. Some memory
allocation might come from there and kernel might write to that memory.
So copying of backup region needs to take place as late as possible.

Thanks
Vivek
