Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3AXN20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab3AXN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:28:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <510104DB.9040403@imgtec.com>
References: <510104DB.9040403@imgtec.com> <50FFCAC4.1050002@synopsys.com> <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-66-git-send-email-vgupta@synopsys.com> <10760.1358945425@warthog.procyon.org.uk> <5100CAAF.8090702@synopsys.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 65/76] ARC: UAPI Disintegrate arch/arc/include/asm
Date: Thu, 24 Jan 2013 13:28:12 +0000
Message-ID: <26124.1359034092@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> wrote:

> > BTW looking at metag port, it seems that <asm/setup.h> does #include
> > <uapi/asm/setup.h>, but latter doesn't exist in the repository - is it
> > generated for you James or is this same issue which David elucidated to
> > above ?
> 
> We have generic-y += setup.h in arch/metag/include/uapi/asm/Kbuild for this

Vineet can't do that as his COMMAND_LINE_SIZE is different to the standard and
also not placed in his UAPI setup.h.

So far, only user-mode Linux and x86 don't put COMMAND_LINE_SIZE in
uapi/asm/setup.h.  Everything else does.

	grep -r 'define\s*COMMAND_LINE_SIZE' arch/*/include | grep -v /uapi/

Not sure if that's needed to build a bootloader or not.

David
