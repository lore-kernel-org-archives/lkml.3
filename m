Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaAWVCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:02:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbaAWVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:02:36 -0500
Date: Thu, 23 Jan 2014 13:02:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Mel Gorman <mgorman@suse.de>,
        gnome@rvzt.net, grawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [PATCH] mm: Ignore VM_SOFTDIRTY on VMA merging, v2
Message-Id: <20140123130235.61e2eca44d92b37936955ff1@linux-foundation.org>
In-Reply-To: <20140123151445.GX1574@moon>
References: <20140122190816.GB4963@suse.de>
	<20140122191928.GQ1574@moon>
	<20140122223325.GA30637@moon>
	<20140123095541.GD4963@suse.de>
	<20140123103606.GU1574@moon>
	<20140123121555.GV1574@moon>
	<20140123125543.GW1574@moon>
	<20140123151445.GX1574@moon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 19:14:45 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> VM_SOFTDIRTY bit affects vma merge routine: if two VMAs has all
> bits in vm_flags matched except dirty bit the kernel can't longer
> merge them and this forces the kernel to generate new VMAs instead.

Do you intend to alter the brk() and binprm code to set VM_SOFTDIRTY?
