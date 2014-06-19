Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbaFSUvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:51:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993AbaFSUvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:51:47 -0400
Date: Thu, 19 Jun 2014 13:51:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Cox, Alan" <alan.cox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "aeb@cwi.nl" <aeb@cwi.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
Message-Id: <20140619135145.9fb9f65404028d656b3f8ec5@linux-foundation.org>
In-Reply-To: <1403203437.17294.25.camel@dabdike.int.hansenpartnership.com>
References: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
	<1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
	<1403203437.17294.25.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 11:43:57 -0700 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:

> Do you have CONFIG_LBD turned on?  That's supposed to let us go up to
> about 16TB before we run out of page index bits.  If you do, we might
> have a variable that's int but should be sector_t somewhere.

I assume the problem is that iov_iter uses size_t (which is 32-bit on
32-bit) and we're trying to use iov_iter for blockdevs.

All this code is new and I've NFI how it's supposed to work and cannot
find a description anywhere.

cc's viro and runs away.
