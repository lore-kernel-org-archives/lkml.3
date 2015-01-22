Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbbAVC0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbbAVC0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:26:13 -0500
Date: Thu, 22 Jan 2015 10:25:44 +0800
From: WANG Chao <chaowang@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Pavel Machek <pavel@ucw.cz>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Xishi Qiu <qiuxishi@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, e820: clean up around sanitize_e820_map()
Message-ID: <20150122022544.GA8670@dhcp-129-179.nay.redhat.com>
References: <1420601859-18439-1-git-send-email-chaowang@redhat.com>
 <alpine.DEB.2.10.1501211450330.2716@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1501211450330.2716@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On 01/21/15 at 02:51pm, David Rientjes wrote:
> On Wed, 7 Jan 2015, WANG Chao wrote:
> 
> > The argument 3 of sanitize_e820_map() will only update upon a successful
> > sanitization. Some of the callers may not be aware of this in the past.
> > Now clean up these callers.
> > 
> > Signed-off-by: WANG Chao <chaowang@redhat.com>
> 
> Nice, but it's incomplete: it should also cleanup 
> default_machine_specific_memory_setup().

default_machine_specific_memory_setup() is special. Because
boot_params.e820_entries is 8bit unsigned, and sanitize_e820_map() which
takes 32bit unsigned, will step on other member of boot_params next to
e820_entries.

Thanks
WANG Chao
