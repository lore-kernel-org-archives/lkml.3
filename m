Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3JIVsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:48:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3JIVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:48:50 -0400
Date: Wed, 9 Oct 2013 14:48:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
Message-Id: <20131009144849.96389b7cdb3a553e52682137@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1309250035480.5312@erqung.pbz>
References: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz>
	<20130923125256.e53b51a137a19a972c6026a2@linux-foundation.org>
	<alpine.LFD.2.03.1309250035480.5312@erqung.pbz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 01:11:54 +0530 (IST) P J P <ppandit@redhat.com> wrote:

> | A few things...
> | - Why is it specific to x86?  Other architcetures use initramfs?
> 
>   No, it is not specific to x86, most likely all architecturess' Makefile 
> would need similar patch. But I haven't looked into those yet.

It would be better to make the change in one place, rather than for
each architecture.  That would appear to involve moving a hunk from
arch/x86/Makefile into init/Makefile, or perhaps ./Makefile.

That way it can still be tested on x86, and it is very reasonable to
assume that it will work as intended on other architectures.

