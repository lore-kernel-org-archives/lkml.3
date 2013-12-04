Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3LDBgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab3LDBgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:36:00 -0500
Date: Wed, 4 Dec 2013 09:35:29 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: mjg59@srcf.ucam.org, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131204013529.GA3298@localhost.localdomain>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131129031048.GE4318@dhcp-16-252.nay.redhat.com>
 <20131202154437.GF18642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202154437.GF18642@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/13 at 10:44am, Vivek Goyal wrote:
> On Fri, Nov 29, 2013 at 11:10:48AM +0800, Baoquan He wrote:
> 
> [..]
> > > +void *arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
> > > +			unsigned long kernel_len, char *initrd,
> > > +			unsigned long initrd_len, char *cmdline,
> > > +			unsigned long cmdline_len)
> > > +{
> > > +	int idx = image->file_handler_idx;
> > > +
> > > +	if (idx < 0)
> > > +		return ERR_PTR(-ENOEXEC);
> > > +
> > > +	return kexec_file_type[idx].load(image, kernel, kernel_len, initrd,
> > > +					initrd_len, cmdline, cmdline_len);
> > > +}
> > > +
> > > +int arch_image_file_post_load_cleanup(struct kimage *image)
> > > +{
> > 
> > Hi Vivek,
> > 
> > This function is defined as one of arch specific fucntion set, why don't
> > we name it in a unified prefix as others.
> 
> I am using "arch_" prefix. What else to use?

I mean in this function series, other functions have name like
arch_kexec_kernel_image_xxx, why this function is lonely, and is named
as arch_kimage_xxx. And here what does the 'k' mean in "kimage", kexec
image or kernel image, I am confused.

> 
> > 
> > And name of the default dummy function in kernel/kexec.c is not consistent
> > with the arch specific one, so currently
> > arch_image_file_post_load_cleanup of x86 arch is not called. Please
> > consider wihch one need be changed.
> 
> Good catch Bao. I should change arch_image_file_post_load_cleanup() to
> arch_kimage_file_post_load_cleanup(), otherwise it never gets called and
> memory leaks.
> 
> Thanks
> Vivek
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
