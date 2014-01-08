Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaAHV7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:59:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaAHV7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:59:32 -0500
Date: Wed, 8 Jan 2014 13:59:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Helge Deller <deller@gmx.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix crash when using XFS on loopback
Message-Id: <20140108135930.9fc1d3a63eeb9a45dcbbb2e8@linux-foundation.org>
In-Reply-To: <CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
	<20140106073549.GA25771@lge.com>
	<alpine.LRH.2.02.1401061237120.6190@file01.intranet.prod.int.rdu2.redhat.com>
	<20140107014159.GA26726@lge.com>
	<52CDBD94.9090808@gmx.de>
	<CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014 23:37:49 +0200 Pekka Enberg <penberg@kernel.org> wrote:

> The patch looks good to me but it probably should go through Andrew's tree.

yup.

page_mapping() will be called quite frequently, and adding a new
test-n-branch in there will be somewhat costly.  We might end up with a
better kernel if we were to instead revert 8456a648cf44f.  How useful
was that patch?
