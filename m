Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaFKXEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:04:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaFKXEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:04:53 -0400
Date: Wed, 11 Jun 2014 16:04:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "George Spelvin" <linux@horizon.com>
Cc: rdunlap@infradead.org, tj@kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH v2 2/3] lib: glob.c: Add CONFIG_GLOB_SELFTEST
Message-Id: <20140611160452.7715d3c4a0cb584e8b507da7@linux-foundation.org>
In-Reply-To: <20140607024928.14178.qmail@ns.horizon.com>
References: <20140607024404.13786.qmail@ns.horizon.com>
	<20140607024928.14178.qmail@ns.horizon.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2014 22:49:28 -0400 "George Spelvin" <linux@horizon.com> wrote:

> This was useful during development, and is retained for future regression
> testing.
> 
> GCC appears to have no way to place string literals in a particular
> section; adding __initconst to a char pointer leaves the string itself
> in the default string section, where it will not be thrown away after
> module load.
> 
> Thus all string constants are kept in explicitly declared and named
> arrays.  Sorry this makes printk a bit harder to read.  At least the
> tests are more compact.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> Persuading GCC to throw away *all* the self-test data after running
> it was surprisingly annoying.

Yeah.  Props for making the attempt.

> The one thing I'm not really sure about is what to do if the self-test
> fails.  For now, I make the module_init function fail too.  Opinions?

The printk should suffice - someone will notice it eventually.

Using KERN_ERR to report a failure might help draw attention to it.

