Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3A2Kh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:37:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52447 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3A2KhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:37:24 -0500
Date: Tue, 29 Jan 2013 11:37:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Backlund <tmb@mageia.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf 3.8-rc build failure:  undefined reference to `strlcpy'
Message-ID: <20130129103722.GE14444@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Backlund <tmb@mageia.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <51074E9D.3040803@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51074E9D.3040803@mageia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 06:22:53AM +0200, Thomas Backlund wrote:
> 
> [tmb@tmb linux-3.8-rc5]$ make -C tools/perf -s V=1
> HAVE_CPLUS_DEMANGLE=1 prefix=%{_prefix} all
> 
> ...
> 
> /tmp/ccJEJv6m.o: In function `main':
> :(.text+0x14): undefined reference to `strlcpy'
> collect2: ld returned 1 exit status
> 
> ...
> 
> This did not show up in 3.7

Ditto here:

/tmp/ccC1kLwn.o: In function `main':
:(.text+0x14): undefined reference to `strlcpy'
collect2: error: ld returned 1 exit status

Someone needs to get HAVE_STRLCPY and tools/perf/util/path.c in order so
that the linker sees it, IMHO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
