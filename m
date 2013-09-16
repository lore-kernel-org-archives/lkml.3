Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3IPIkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:40:04 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:50217 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3IPIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:40:03 -0400
Message-ID: <1379320800.15916.15.camel@linux-fkkt.site>
Subject: Re: Why does test_bit() take a volatile addr?
From: Oliver Neukum <oliver@neukum.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: torvalds@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 10:40:00 +0200
In-Reply-To: <87ioy11k8s.fsf@rustcorp.com.au>
References: <87ioy11k8s.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 13:38 +0930, Rusty Russell wrote:
> Predates git, does anyone remember the rationale?
> 
> ie:
>         int test_bit(int nr, const volatile unsigned long *addr)
> 
> I noticed because gcc failed to elimiate some code in a patch I was
> playing with.
> 
> I'm nervous about subtle bugs involved in ripping it out, even if noone
> knows why.  Should I add __test_bit()?

It seems to me that if you do

b = *ptr & 0xf;
c = b << 2;
if (test_bit(1, ptr))

the compiler could optimize away the memory access on ptr without
the volatile. We'd have to add a lot of mb().

	Regards
		Oliver


