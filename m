Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3KUTNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:13:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3KUTNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:13:32 -0500
Date: Thu, 21 Nov 2013 14:13:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131121191305.GK16208@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
 <20131121190620.GA25951@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121190620.GA25951@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 07:06:20PM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 11:03:50AM -0800, Greg KH wrote:
> 
> > This could be done as we do with modules, and just tack the signature
> > onto the end of the 'blob' of the image.  That way we could use the same
> > tool to sign the binary as we do for modules, and save the need for
> > extra parameters in the syscall.
> 
> That would require a certain degree of massaging from userspace if we 
> want to be able to use the existing Authenticode signatures. Otherwise 
> we need to sign kernels twice.

I was thinking oof signing the same kernel twice. Can I sign authenticode
signed kernel again (using RSA signature as we do for modules) and append
the signature to bzImage. 

I am wondering if authenticode signature verification will fail due
to this extra signature at the end of bzImage. pjones thought that it
will break authenticode signature verification. CCing him.

Thanks
Vivek
