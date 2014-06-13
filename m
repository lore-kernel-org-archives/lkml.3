Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaFMKRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:17:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59258 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaFMKRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:17:16 -0400
Date: Fri, 13 Jun 2014 12:17:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 09/13] purgatory: Core purgatory functionality
Message-ID: <20140613101713.GD4751@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-10-git-send-email-vgoyal@redhat.com>
 <20140605200523.GB26110@pd.tnic>
 <20140606195104.GM1526@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140606195104.GM1526@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 03:51:04PM -0400, Vivek Goyal wrote:
> On Thu, Jun 05, 2014 at 10:05:23PM +0200, Borislav Petkov wrote:
> 
> [..]
> > > @@ -249,6 +254,7 @@ archclean:
> > >  	$(Q)rm -rf $(objtree)/arch/x86_64
> > >  	$(Q)$(MAKE) $(clean)=$(boot)
> > >  	$(Q)$(MAKE) $(clean)=arch/x86/tools
> > 
> > ifeq ($(CONFIG_KEXEC),y)
> > 	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
> > endif
> 
> Hmm.., is it strictly required? I am wondering what happens if I build
> a kernel with CONFIG_KEXEC=y, then set CONFIG_KEXEC=n and do "make clean".

Try it - it works here.

> I think I will still like any files in arch/x86/purgatory to be cleaned
> despite the fact that CONFIG_KEXEC=n. Isn't it?

Yep, that works. Conversely, we don't want people who haven't enabled
KEXEC ever to have unrelated cleanup delay.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
