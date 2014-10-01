Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaJANzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:55:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaJANzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:55:13 -0400
Message-ID: <542C07BF.6030703@suse.cz>
Date: Wed, 01 Oct 2014 15:55:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] limit _shipped to c,h and S files
References: <20141001133659.GC5560@opentech.at>
In-Reply-To: <20141001133659.GC5560@opentech.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-01 15:36, Nicholas Mc Guire wrote:
> 
> limit _shipped to c,h and S files
> 
> _shipped targets are intended for generated source files which should
> not permit .o binary blobs which is currently the case. This patch
> simply restricts _shipped targets to .c, .h and .S files.

Patches 1/3 and 3/3 are fine, but I'm not convinced about this one.
Sure, binary blobs are often distributed as *.o_shipped, but they are
not going away if you remove support for _shipped.


> Note that this patch breaks the handline of drivers/net/wan/wanxlfw.inc_shipped
> which probably really should be moved to a loadable firmware and use
> request_firmware - a short term fix could be to move it to a .h file.

At a minimum, the patch series should address this before limiting
support for *_shipped.

Michal
