Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHTGYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:24:13 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:44499 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTGYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:24:11 -0400
Date: Wed, 20 Aug 2014 08:24:08 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Baoquan He <bhe@redhat.com>,
        Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Greg Kroah-Hartman <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        WANG Chao <chaowang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        ubuntu@iam.tj
Subject: REGRESSION: 8fc5b4d: Unable to compile x86_64 kernel with x86_32
 userland
Message-ID: <20140820062408.GB14660@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Vivek Goyal <vgoyal@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>, Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	WANG Chao <chaowang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
	ubuntu@iam.tj
References: <20140820060423.GA14660@glanzmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820060423.GA14660@glanzmann.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,
commit 8fc5b4d introduces a regression that no longer allows to compile
x86_64 kernel under x86_32 userland. TJ on freenode/#kernel did analyze
it:

> (mini) [~/work/linux-2.6] make
> scripts/kconfig/conf --silentoldconfig Kconfig
>   CHK     include/config/kernel.release
>   UPD     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CC      arch/x86/purgatory/purgatory.o
> arch/x86/purgatory/purgatory.c:1:0: error: code model 'large' not supported in the 32 bit mode
> make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
> make: *** [archprepare] Error 2

08:10 < TJ-> Glanzmann: The purgatory code from kexec is specifying ".code64"
08:11 < TJ-> Glanzmann: so when your local 32-bit linker tries to deal with that ... it errors
08:14 < TJ-> Glanzmann: there's only one introducing the purgatory stuff
08:14 < TJ-> 8fc5b4d Fri Aug 8 15:57:32 2014 -0700 Vivek Goyal purgatory: core purgatory functionality

Cheers,
        Thomas
