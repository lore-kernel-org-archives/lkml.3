Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaAQTRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:17:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaAQTRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:17:46 -0500
Date: Fri, 17 Jan 2014 14:17:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140117191714.GH24394@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <alpine.LRH.2.00.1311222136030.9932@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1311222136030.9932@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:42:52PM +0100, Jiri Kosina wrote:

[..]
> > @@ -843,7 +1075,11 @@ static int kimage_load_normal_segment(struct kimage *image,
> >  				PAGE_SIZE - (maddr & ~PAGE_MASK));
> >  		uchunk = min(ubytes, mchunk);
> >  
> > -		result = copy_from_user(ptr, buf, uchunk);
> > +		/* For file based kexec, source pages are in kernel memory */
> > +		if (image->file_mode)
> > +			memcpy(ptr, buf, uchunk);
> 
> Very minor nit I came across when going through the patchset -- can't we 
> use some different buffer for the file-based kexec that's not marked 
> __user here? This really causes some eye-pain when looking at the code.

Hi Jiri,

Sorry, responding to your comment after a very long time.

Now I have made buf field a union as it can either be a user pointer or
a kernel pointer depending on which kexec syscall has been used. Now
caller needs to either use segment->buf or segment->kbuf based on the
context of code.

	kexec_segment {
		union {
			void __user *buf;
			void *kbuf;
		};
	}

Thanks
Vivek
