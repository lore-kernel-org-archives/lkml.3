Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaHFQDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:03:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48309 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaHFQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:03:03 -0400
Date: Wed, 6 Aug 2014 17:02:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ebiederm@xmission.com, ian.molton@codethink.co.uk
Subject: Re: [PATCH] seq_file: Allow private data to be supplied on seq_open
Message-ID: <20140806160259.GR18016@ZenIV.linux.org.uk>
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:39:53PM +0100, Rob Jones wrote:

> At the moment these consumers have to obtain the struct seq_file pointer
> (stored by seq_open() in file->private_data) and then store a pointer to
> their own data in the private field of the struct seq_file so that it
> can be accessed by the iterator functions.
> 
> Although this is not a long piece of code it is unneccessary boilerplate.

How many of those do we actually have?

> seq_open() remains in place and its behaviour remains unchanged so no
> existing code should be broken by this patch.

I have no objections against such helper, but I's rather have it
implemented via seq_open() (and as a static inline, not an export),
not the other way round.  Oh, and conversion of at least some users would
be nice to have as well...
