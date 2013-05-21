Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3EUIK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:10:59 -0400
Received: from ozlabs.org ([203.10.76.45]:37345 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab3EUIKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:10:40 -0400
Date: Tue, 21 May 2013 18:10:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        zhangyanfei@cn.fujitsu.com, Jiri Kosina <jkosina@suse.cz>,
        Michael Ellerman <michael@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC: kernel: need return the related error code when
 failure occurs.
Message-ID: <20130521081031.GA29303@iris.ozlabs.ibm.com>
References: <519B0ACA.6090008@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519B0ACA.6090008@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 01:48:58PM +0800, Chen Gang wrote:
> 
> When error occurs, need return the related error code to let upper
> caller know about it.
> 
> ppc_md.nvram_size() can return the error code (e.g. core99_nvram_size()
> in 'arch/powerpc/platforms/powermac/nvram.c').
> 
> And when '*ppos >= size', need return -ESPIPE (Illegal seek)

Why?  When *ppos >= size, it should return 0 (end of file) in my opinion.
ESPIPE means that any seek would be ineffective, not that a particular
seek went out of bounds.

Paul.
