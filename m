Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaK0ROX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:14:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31147 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaK0ROW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:14:22 -0500
MIME-Version: 1.0
Message-ID: <5a9dde8d-1936-4910-a78a-15d4f9bfffc2@default>
Date: Thu, 27 Nov 2014 09:14:11 -0800 (PST)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <bp@suse.de>
Cc: <konrad.wilk@oracle.com>, <x86@kernel.org>, <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <david.vrabel@citrix.com>,
        <rshendershot@mchsi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- bp@suse.de wrote:

> On Thu, Nov 27, 2014 at 11:21:19AM -0500, Konrad Rzeszutek Wilk
> wrote:
> > > Ok, but let's have a clean design: maybe have a weak default stub
> which
> > > returns false when PARAVIRT is not enabled in the .config and then
> add
> > > an override in, say, arch/x86/kernel/paravirt.c which returns true
> when
> > > running as a guest. Something like that, at least.
> > 
> > You are describing 'paravirt_enabled()' :-)
> 
> Haha.
> 
> Although I have a suspicion this won't work either because we're
> loading
> microcode very early on 32-bit, before paging has been enabled, and
> accessing pv_info.paravirt_enabled will probably go boom. AFAICT, from
> a
> quick glance.


The overnight tests passed. This includes baremetal, HVM and PV(H), 32- and 64-bit.

-boris
