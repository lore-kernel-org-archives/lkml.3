Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab3LJWgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:36:22 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43527 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3LJWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:36:21 -0500
Date: Wed, 11 Dec 2013 09:06:15 +1030
From: Alan Modra <amodra@gmail.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Binutils <binutils@sourceware.org>
Subject: Re: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie
 -Ttext-segment=
Message-ID: <20131210223615.GA10239@bubble.grove.modra.org>
Mail-Followup-To: "H.J. Lu" <hjl.tools@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Binutils <binutils@sourceware.org>
References: <CAMe9rOob2T+VWkZyHpaoBy6fUeTyAocpw4-cBpdrar2rtdAeew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMe9rOob2T+VWkZyHpaoBy6fUeTyAocpw4-cBpdrar2rtdAeew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 07:10:23PM -0800, H.J. Lu wrote:
> Linker sets e_type in ELF header to ET_DYN for -pie -Ttext-segment=0xXXX.
> When I added -Ttext-segment=0xXXX, one goal was to load
> small model executable above 4GB on Linux/x86-64, which
> was done with -pie -Ttext-segment=0xXXX.  But -pie sets
> e_type in ELF header to ET_DYN and kernel may ignore
> p_vaddr in ELF header to load ET_DYN binary at a random
> address.  This patch changes ld to set e_type in ELF header
> to ET_EXEC if the first PT_LOAD segment has non-zero
> p_vaddr.  If this is unacceptable as generic ELF change,
> I can make it specific to x86.

Well, I suppose it's a hack to use ET_DYN for executables in the first
place, so one more hack in the linker hardly matters.  Why not just
patch the kernel though?  The kernel can look at the first PT_LOAD
header just as easily as the linker, and it's the kernel that is doing
the loading after all.

-- 
Alan Modra
Australia Development Lab, IBM
