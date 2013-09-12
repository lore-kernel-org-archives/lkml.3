Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3ILOZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:25:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43077 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3ILOZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:25:04 -0400
Date: Thu, 12 Sep 2013 16:25:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, matthew.garrett@nebula.com
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Message-ID: <20130912142537.GA10143@x1.alien8.de>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
 <522FA2A8.8080703@zytor.com>
 <20130911114419.GB31551@x1.alien8.de>
 <20130911134534.GB15364@redhat.com>
 <20130911143216.GA933@x1.alien8.de>
 <20130912064930.GA5288@dhcp-16-126.nay.redhat.com>
 <20130912125350.GB9280@x1.alien8.de>
 <20130912131930.GC28500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130912131930.GC28500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 09:19:30AM -0400, Vivek Goyal wrote:
> I did not understand this argument that we need to use high virtual
> addresses because windows is using it and now we end up creating
> fixed EFI addresses and that becomes an ABI. If EFI implementations

The only thing that becomes sort-of ABI is that we start the mappings at
-4G virtual.

> are dependent on high addresses being passed, shouldn't it be those
> implementations which need to be fixed instead of kernel fixing EFI

Right, this is the biggest issue with firmware - vendors like to declare
those as End-of-Life platforms and for them there are no fixes. This is
the reason why we don't do the 1:1 mappings.

> addresses in higher region.

The thing is, reportedly some Apple UEFI implementations cannot stomach
1:1 SetVirtualAddressMap mappings. Also, the high addresses mappings is
the only thing that vendors test on windoze so in that field we want
to do what windoze does as this is the only thing that gets reliable
testing.

But I get the feeling we're feeling up stuff in the dark as firmware is
closed crap which we cannot look at.

HTH.

-- 
Regards/Gruss,
Boris.
