Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaBYTfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:35:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaBYTfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:35:24 -0500
Date: Tue, 25 Feb 2014 20:35:19 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, mjg59@srcf.ucam.org, jkosina@suse.cz,
        greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com
Subject: Re: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140225203519.77abfa8d@hananiah.suse.cz>
In-Reply-To: <20140224164131.GJ4631@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
	<1390849071-21989-7-git-send-email-vgoyal@redhat.com>
	<20140221145910.GE11531@pd.tnic>
	<20140224164131.GJ4631@redhat.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 11:41:31 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Feb 21, 2014 at 03:59:10PM +0100, Borislav Petkov wrote:
> 
>[...]
> > 
> > ...
> > 
> > > diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
> > > index d6629d4..5fddb1b 100644
> > > --- a/include/uapi/linux/kexec.h
> > > +++ b/include/uapi/linux/kexec.h
> > > @@ -13,6 +13,10 @@
> > >  #define KEXEC_PRESERVE_CONTEXT	0x00000002
> > >  #define KEXEC_ARCH_MASK		0xffff0000
> > >  
> > > +/* Kexec file load interface flags */
> > > +#define KEXEC_FILE_UNLOAD	0x00000001
> > > +#define KEXEC_FILE_ON_CRASH	0x00000002
> > 
> > BIT()
> 
> What's that?

#define BIT(nr)                 (1UL << (nr))

For my part I'm not convinced it's a better way to do it, unless
Borislav also wanted to suggest adding an enum for the bit number
values...

Petr T
