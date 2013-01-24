Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3AXFtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:49:02 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:49116 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3AXFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:48:58 -0500
Message-ID: <5100CAAF.8090702@synopsys.com>
Date: Thu, 24 Jan 2013 11:16:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: David Howells <dhowells@redhat.com>
CC: James Hogan <james.hogan@imgtec.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>
Subject: Re: [PATCH v2 65/76] ARC: UAPI Disintegrate arch/arc/include/asm
References: <50FFCAC4.1050002@synopsys.com> <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-66-git-send-email-vgupta@synopsys.com> <10760.1358945425@warthog.procyon.org.uk>
In-Reply-To: <10760.1358945425@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 06:20 PM, David Howells wrote:
> Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> 
>> I generated this patch using the scripts you provided. If these look OK to
>> you, can you please ACK.
> 
> You need to take a look at uapi/asm/setup.h.  It's created as an empty file -
> which will get discarded by patch.  Do you actually need a UAPI instance of
> that?
> 
> David
> 

Given that setup.h is exported by include/uapi/asm-generic/Kbuild.asm (as part of
userspace header ABI) there's no way we can avoid it's uapi sibling - even if
empty. But to workaround patch discarding it, I will add a placeholder comment in
generated setup.h (just like you did for arch/cris). Would that take care of it ?

BTW looking at metag port, it seems that <asm/setup.h> does #include
<uapi/asm/setup.h>, but latter doesn't exist in the repository - is it generated
for you James or is this same issue which David elucidated to above ?


-Vineet
