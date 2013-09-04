Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762341Ab3IDKua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:50:30 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:60363 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233Ab3IDKu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:50:28 -0400
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module
 signatures when in Secure Boot mode
From: joeyli <jlee@suse.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org
In-Reply-To: <20130830234133.GR20828@hansolo.jdub.homelinux.org>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	 <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
	 <20130829183713.GT20828@hansolo.jdub.homelinux.org>
	 <522104A6.5000700@zytor.com>
	 <20130830234133.GR20828@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Sep 2013 18:51:17 +0800
Message-ID: <1378291877.6380.74.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2013-08-30 於 19:41 -0400，Josh Boyer 提到：
> On Fri, Aug 30, 2013 at 01:46:30PM -0700, H. Peter Anvin wrote:
> > On 08/29/2013 11:37 AM, Josh Boyer wrote:
> > >>  	setup_efi_pci(boot_params);
> > >> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> > >> index c15ddaf..d35da96 100644
> > >> --- a/arch/x86/include/uapi/asm/bootparam.h
> > >> +++ b/arch/x86/include/uapi/asm/bootparam.h
> > >> @@ -131,7 +131,8 @@ struct boot_params {
> > >>  	__u8  eddbuf_entries;				/* 0x1e9 */
> > >>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
> > >>  	__u8  kbd_status;				/* 0x1eb */
> > >> -	__u8  _pad5[3];					/* 0x1ec */
> > >> +	__u8  secure_boot;				/* 0x1ec */
> > >> +	__u8  _pad5[2];					/* 0x1ec */
> > >>  	/*
> > >>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
> > >>  	 *
> > > 
> > > You need to include the following chunk of code with this, otherwise the
> > > secure_boot variable gets cleared.
> > > 
> > 
> > Not really.
> > 
> > There are three cases:
> > 
> > 1. Boot stub only.  Here we do the right thing with the bootparams.
> > 2. Boot loader bypasses the boot stub completely.  Here we MUST NOT do
> >    what you suggest above.
> > 3. Boot stub with a boot_params structure passed in.  Here we should
> >    run sanitize_boot_params() (an inline for a reason) in the boot
> >    stub, before we set the secure_boot field.  Once that is done, we
> >    again don't need that modification.
> 
> OK.  If 3 works, then great.  All I know is that Fedora has been
> carrying the above hunk for months and it was missing in this patch set.
> So when I went to test it, the patches didn't do anything because the
> secure_boot field was getting cleared.
> 
> I'm more than happy to try option 3, and I'll poke at it next week
> unless someone beats me to it.
> 
> josh

The secure_boot field cleaned by sanitize_boot_params() when using grub2
linuxefi to load efi stub kernel.
I printed the boot_params->sentinel value, confirm this value is NOT 0
when running grub2 linuxefi path, the entry point is efi_stub_entry. 

On the other hand,
the sentinel value is 0 when direct run efi stub kernel in UEFI shell,
the secure_boot field can keep.

Does that mean grub2 should clean the sentinel value? or we move the get
secure_boot value to efi_init()?


Thanks a lot!
Joey Lee

