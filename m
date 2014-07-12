Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaGLXEC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:04:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaGLXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:03:59 -0400
Date: Sat, 12 Jul 2014 16:08:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: checkpatch.pl misses list_for_each_entry() coding style issues
Message-ID: <20140712230828.GA15827@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

The following function:

$ cat foo.c 

static int foo_init(void)
{

	list_for_each_entry(foo, &foo, list)
	{
		do_something_foo(foo);
	}

	return 0;
}

Will not be caught by checkpatch:

$ ./scripts/checkpatch.pl --file foo.c 
total: 0 errors, 0 warnings, 11 lines checked

foo.c has no obvious style problems and is ready for submission.


Any way to fix that up?

thanks,

greg k-h
