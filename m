Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3KUMLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:11:32 -0500
Received: from ozlabs.org ([203.10.76.45]:41195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab3KUMLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:11:30 -0500
Date: Thu, 21 Nov 2013 23:11:28 +1100
From: Michael Ellerman <mpe@ellerman.id.au>
To: Anton Blanchard <anton@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (Linus'
 tree related - powerpc)
Message-ID: <20131121121127.GG15913@concordia>
References: <20131121134622.a853064a1b5a8355e5077737@canb.auug.org.au>
 <20131121143334.44be4231@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121143334.44be4231@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:33:34PM +1100, Anton Blanchard wrote:
> 
> Hi,
> 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > <stdin>:1:0: error: -mcall-aixdesc must be big endian
> 
> Urgh, allyesconfig is building an LE kernel. Ian: do we need to reverse
> the polarity of the option, and call it CONFIG_CPU_BIG_ENDIAN?

More or less. See what we did with PPC_WERROR, for the same reasons, so
that it was off for an allyesconfig.

    config PPC_DISABLE_WERROR
            bool "Don't build arch/powerpc code with -Werror"
            default n
    
    config PPC_WERROR
            bool
            depends on !PPC_DISABLE_WERROR
            default y

cheers
