Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab3DISJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763208Ab3DISJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:09:10 -0400
Date: Tue, 9 Apr 2013 14:08:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Milan Broz <gmazyland@gmail.com>
cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: [dm-devel] dm-crypt performance
In-Reply-To: <5151FF82.6090405@gmail.com>
Message-ID: <Pine.LNX.4.64.1304091352320.10025@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Mar 2013, Milan Broz wrote:

> - Are we sure we are not inroducing some another side channel in disc
> encryption? (Unprivileged user can measure timing here).
> (Perhaps stupid reason but please do not prefer performance to security
> in encryption. Enough we have timing attacks for AES implementations...)

So use serpent - it is implemented without any data-dependent lookup 
tables, so it has no timing attacks.

AES uses data-dependent lookup tables, on CPU with hyperthreding, the 
second thread can observe L1 cache footprint done by the first thread and 
get some information about data being encrypted...

Mikulas
