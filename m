Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3AMX4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:56:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53579 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3AMX4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:56:42 -0500
Date: Mon, 14 Jan 2013 00:54:49 +0000
From: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: kconfig: qconf.cc: fix a compiliation error
 when using make xconfig
Message-ID: <20130114005449.GA5499@rak.local>
References: <1358047720-10358-1-git-send-email-rkmahefa@gmail.com>
 <50F31E2C.3050104@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F31E2C.3050104@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 janvier 2013 à 09:50:52, Michal Marek a écrit :
> On 13.1.2013 04:28, Tiana Rakotovao Andriamahefa wrote:
> > When using make xconfig, the following compilation error appears :
> >    /usr/include/qt3/qvaluelist.h:427:13: error: ‘ptrdiff_t’ does not name a type
> > Including stddef.h in scripts/kconfig/qconf.cc permits to avoid this error.
> 
> This is a bug in the Qt header. Is Qt3 still maintained?

This seems to be a common c++ issue since the begining of 2011.

Some Qt3 headers use ptrdiff_t which is defined in stddef.h. They also use some 
c++ headers, and rely on them to include stddef.h. However, since GCC-4.6, 
those c++ headers do not include stddef.h anymore. So, include <stddef.h> 
fixes it.

This issue is reported here:  http://gcc.gnu.org/gcc-4.6/porting_to.html?

-- 
Tiana Rakotovao Andriamahefa
