Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbbA1Uya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbbA1UyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:21 -0500
Date: Wed, 28 Jan 2015 09:48:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        kexec@lists.infradead.org, Andy Lutomirski <luto@amacapital.net>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Edited kexec_load(2) [kexec_file_load()] man page for review
Message-ID: <20150128144803.GC15342@redhat.com>
References: <545FBDDD.9060801@gmail.com>
 <20141111213037.GA31445@redhat.com>
 <54ADA284.30502@gmail.com>
 <20150112221634.GD16162@redhat.com>
 <54B91271.3000600@gmail.com>
 <20150127142459.GA12851@redhat.com>
 <54C89816.8030709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C89816.8030709@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:04:38AM +0100, Michael Kerrisk (man-pages) wrote:

Hi Michael,

[..]
> >> * the number of bytes copied from userspace is min(bufsz, memsz)
> > 
> > Yes. bufsz can not be more than memsz. There is a check to validate
> > this in kernel.
> > 
> > 	result = -EINVAL;
> > 	for (i = 0; i < nr_segments; i++) {
> > 		if (image->segment[i].bufsz > image->segment[i].memsz)
> > 			return result;
> > 	}
> 
> Okay. So it's more precise to leave discussion of min(bufz, memsz) 
> out of the man page just to say: bufsz bytes are transferred; 
> if bufsz < memsz, then the excess bytes in the target region are 
> filled with zeros. Right?

Sounds good.

[..]
> > Both mem and memsz need to be page aligned.
> 
> And the error if not is EADDRNOTAVAIL, right?

Yes.

> 
> >> And one further question. Other than the fact that they are used with 
> >> different system calls, what is the difference between KEXEC_ON_CRASH 
> >> and KEXEC_FILE_ON_CRASH?
> > 
> > Right now I can't think of any other difference. They both tell respective
> > system call that this kernel needs to be loaded in reserved memory region
> > for crash kernel.
> 
> Okay.
> 
> I've made various adjustments to the page in the light of your comments 
> above. Thanks!

Thank you for following it up and improving kexec man page.

Thanks
Vivek
