Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3IDGMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:12:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43809 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab3IDGL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:11:58 -0400
Date: Wed, 4 Sep 2013 08:12:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Subject: Re: [PATCH 2/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20130904061221.GA17791@x1.alien8.de>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
 <20130829092804.5476.95588.stgit@localhost6.localdomain6>
 <20130831052252.GC12617@x1.alien8.de>
 <5223F8DB.3040506@jp.fujitsu.com>
 <20130902071318.GA3406@x1.alien8.de>
 <52245D94.5050702@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52245D94.5050702@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 06:42:44PM +0900, HATAYAMA Daisuke wrote:
> The reason why I don't lookup BSP flag in MSR is that it's impossible.
> To read MSR of some CPU, we need to use rdmsr instruction on the CPU.
> However, in case of this issue, the BSP is halting or running in
> the kdump 1st kernel.

Yes, and on the AP, that flag would be cleared which makes it not a BSP.

> A whole explanation is written in the patch description.

Those tend to get lost in git history when a bunch of whitespace jerk
offs appear ontop. So a nicely written comment in the code could be very
helpful.

Thanks.

-- 
Regards/Gruss,
Boris.
