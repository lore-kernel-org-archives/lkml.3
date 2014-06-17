Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaFQOJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:09:14 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:47099
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932752AbaFQOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:09:13 -0400
Date: Tue, 17 Jun 2014 09:09:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Bob Liu <bob.liu@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: NULL ptr deref in remove_migration_pte
In-Reply-To: <539F5BC5.3010501@oracle.com>
Message-ID: <alpine.DEB.2.11.1406170907540.12946@gentwo.org>
References: <534E9ACA.2090008@oracle.com> <5367B365.1070709@oracle.com> <537FE9F3.40508@oracle.com> <alpine.LSU.2.11.1405261255530.3649@eggly.anvils> <538498A1.7010305@oracle.com> <alpine.LSU.2.11.1406092104330.12382@eggly.anvils>
 <539F5BC5.3010501@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Sasha Levin wrote:

> It took some time to hit something here, but I think that the following
> is related:

This related thing looks like someone did a random memset. The SLUB
diagnostic show the object, redzone and padding were overwritten with
zeros.

> [  494.710068] =============================================================================
> [  494.710068] BUG page->ptl (Not tainted): Redzone overwritten
> [  494.710068] -----------------------------------------------------------------------------
> [  494.710068]
> [  494.710068] INFO: 0xffff8804e4730e58-0xffff8804e4730e5f. First byte 0x0 instead of 0xbb
> [  494.710068] INFO: Slab 0xffffea001391cc00 objects=40 used=40 fp=0x          (null) flags=0x56fffff80004080
> [  494.710068] INFO: Object 0xffff8804e4730e10 @offset=3600 fp=0x          (null)
> [  494.710068]
> [  494.710068] Bytes b4 ffff8804e4730e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  494.710068] Object ffff8804e4730e10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  494.710068] Object ffff8804e4730e20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  494.710068] Object ffff8804e4730e30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  494.710068] Object ffff8804e4730e40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  494.710068] Object ffff8804e4730e50: 00 00 00 00 00 00 00 00                          ........
> [  494.710068] Redzone ffff8804e4730e58: 00 00 00 00 00 00 00 00                          ........
> [  494.710068] Padding ffff8804e4730f98: 00 00 00 00 00 00 00 00                          ........
