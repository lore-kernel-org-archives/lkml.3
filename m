Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3EVR52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:57:28 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:39569 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3EVR50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:57:26 -0400
Date: Wed, 22 May 2013 19:57:17 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Sanjay Lal <sanjayl@kymasys.com>, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, linux-ia64@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH -next] ia64, metag: Do not export min_low_pfn in
 arch-specific code
Message-ID: <20130522175717.GG10769@linux-mips.org>
References: <1367086831-10740-1-git-send-email-geert@linux-m68k.org>
 <CAAG0J982gbca3XHHSpTHgqPgeGyJRtG8Lm1cWsT0HsThqdFeMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAG0J982gbca3XHHSpTHgqPgeGyJRtG8Lm1cWsT0HsThqdFeMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 11:24:35AM +0100, James Hogan wrote:

> On 27 April 2013 19:20, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > As of commit 787dcbe6984b3638e94f60d807dcb51bb8a07211 ("MIPS: Export
> > symbols used by KVM/MIPS module"), min_low_pfn is already exported by
> > the generic mm/bootmem.c, causing:
> >
> > WARNING: vmlinux: 'min_low_pfn' exported twice. Previous export was in vmlinux
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> This has been pointed out several times and needs fixing in the mips
> tree where the warning was introduced.

I've changed the MIPS code to no longer require the export of min_low_pfn
and dropped the export of that particular file.  I still see that IA-64
and metag export min_low_pfn so maybe it should be exported from mm/
after all?

  Ralf
