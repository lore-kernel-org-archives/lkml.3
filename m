Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaETRVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:21:39 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:54927 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaETRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:21:38 -0400
Date: Tue, 20 May 2014 21:21:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/4] x86,mm: Improve _install_special_mapping and fix x86
 vdso naming
Message-ID: <20140520172134.GJ2185@moon>
References: <cover.1400538962.git.luto@amacapital.net>
 <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:58:33PM -0700, Andy Lutomirski wrote:
> Using arch_vma_name to give special mappings a name is awkward.  x86
> currently implements it by comparing the start address of the vma to
> the expected address of the vdso.  This requires tracking the start
> address of special mappings and is probably buggy if a special vma
> is split or moved.
> 
> Improve _install_special_mapping to just name the vma directly.  Use
> it to give the x86 vvar area a name, which should make CRIU's life
> easier.
> 
> As a side effect, the vvar area will show up in core dumps.  This
> could be considered weird and is fixable.  Thoughts?
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Hi Andy, thanks a lot for this! I must confess I don't yet know how
would we deal with compat tasks but this is 'must have' mark which
allow us to detect vvar area!
