Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3LDRTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:19:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3LDRTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:19:31 -0500
Date: Wed, 4 Dec 2013 12:19:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: mjg59@srcf.ucam.org, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131204171904.GA19087@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131129031048.GE4318@dhcp-16-252.nay.redhat.com>
 <20131202154437.GF18642@redhat.com>
 <20131204013529.GA3298@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204013529.GA3298@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:35:29AM +0800, Baoquan He wrote:
> On 12/02/13 at 10:44am, Vivek Goyal wrote:
> > On Fri, Nov 29, 2013 at 11:10:48AM +0800, Baoquan He wrote:
> > 
> > [..]
> > > > +void *arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
> > > > +			unsigned long kernel_len, char *initrd,
> > > > +			unsigned long initrd_len, char *cmdline,
> > > > +			unsigned long cmdline_len)
> > > > +{
> > > > +	int idx = image->file_handler_idx;
> > > > +
> > > > +	if (idx < 0)
> > > > +		return ERR_PTR(-ENOEXEC);
> > > > +
> > > > +	return kexec_file_type[idx].load(image, kernel, kernel_len, initrd,
> > > > +					initrd_len, cmdline, cmdline_len);
> > > > +}
> > > > +
> > > > +int arch_image_file_post_load_cleanup(struct kimage *image)
> > > > +{
> > > 
> > > Hi Vivek,
> > > 
> > > This function is defined as one of arch specific fucntion set, why don't
> > > we name it in a unified prefix as others.
> > 
> > I am using "arch_" prefix. What else to use?
> 
> I mean in this function series, other functions have name like
> arch_kexec_kernel_image_xxx, why this function is lonely, and is named
> as arch_kimage_xxx. And here what does the 'k' mean in "kimage", kexec
> image or kernel image, I am confused.

kimage is name is structure which is containing all the data relevant
to loading of file. 

I guess I can use arch_kimage_file_post_load_cleanup().

Thanks
Vivek
