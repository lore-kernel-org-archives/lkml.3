Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3LBPbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:31:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3LBPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:31:07 -0500
Date: Mon, 2 Dec 2013 10:30:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 6/6] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20131202153037.GD18642@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
 <20131128112816.GC4318@dhcp-16-252.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128112816.GC4318@dhcp-16-252.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 07:28:16PM +0800, Baoquan He wrote:

[..]
> > +int crash_copy_backup_region(struct kimage *image)
> > +{
> 
> Why need this func be called, backup region has been added into crash
> segment by kexec_add_buffer, and then buffer copy is done in
> kimage_load_crash_segment. I think this copy is handled twice. Please
> correct me if I am wrong.
> 

Hi Bao,

kexec_add_buffer() will copy the backup region but it will happen when
crash kernel is loaded. We want snapshot of backup region at the time
of crash and that's why this second call to copy backup region and it
is executed after the crash.

Thanks
Vivek
