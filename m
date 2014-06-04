Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaFDRle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:41:34 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:44122 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbaFDRlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:41:32 -0400
Date: Wed, 4 Jun 2014 12:41:29 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Jan Kara <jack@suse.cz>
cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: fs: memory corruption in names_cache
In-Reply-To: <20140604145857.GD14887@quack.suse.cz>
Message-ID: <alpine.DEB.2.10.1406041238380.12633@gentwo.org>
References: <538F2E1C.3050608@oracle.com> <20140604145857.GD14887@quack.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Jan Kara wrote:

> On Wed 04-06-14 10:33:00, Sasha Levin wrote:
> > Hi all,
> >
> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > kernel I've stumbled on the following spew:
>   Hum, I'd really suspect more a SLUB bug - the area has poisoning 0x6b
> (POISON_FREE) instead of expected poisoning 0x5a (POISON_INUSE). Or maybe
> I'm just mistaken - could some SLUB guy comment?

Well yes that is really weird. The last byte is 0xa5 (end of object) which
indicates that the padding space has been treated as an object. Could be
metadata corruption. The slab is empty but there is an object allocated in
there???

