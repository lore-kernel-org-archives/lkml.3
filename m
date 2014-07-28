Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaG1Pam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:30:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaG1Pak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:30:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140728152457.GA2901@himangi-Dell>
References: <20140728152457.GA2901@himangi-Dell>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] afs: delete double assignment
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2917.1406561398.1@warthog.procyon.org.uk>
Date: Mon, 28 Jul 2014 16:29:58 +0100
Message-ID: <2918.1406561398@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Himangi Saraogi <himangi774@gmail.com> wrote:

> -	afs_uuid.time_hi_and_version = (uuidtime >> 48) & AFS_UUID_TIMEHI_MASK;
>  	afs_uuid.time_hi_and_version = AFS_UUID_VERSION_TIME;
>  
>  	get_random_bytes(&clockseq, 2);
>  	afs_uuid.clock_seq_low = clockseq;
> -	afs_uuid.clock_seq_hi_and_reserved =
> -		(clockseq >> 8) & AFS_UUID_CLOCKHI_MASK;
>  	afs_uuid.clock_seq_hi_and_reserved = AFS_UUID_VARIANT_STD;

This might be the wrong thing to do.  I wonder if the lines following the ones
deleted should be "|=" rather than "=".  I'll have a look into it.

David
