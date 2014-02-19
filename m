Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaBSVzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbaBSVzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:55:18 -0500
Date: Wed, 19 Feb 2014 16:55:05 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
Message-ID: <20140219215505.GA28876@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	David Rientjes <rientjes@google.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
References: <20140218220606.GA9712@redhat.com>
 <20140219134025.fcd70941e1ec98723a1bd230@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219134025.fcd70941e1ec98723a1bd230@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:40:25PM -0800, Andrew Morton wrote:
 
 > Switching `make_it_fail' to unsigned makes the test simpler but it does
 > rather muck up the typing in there.  task_struct.make_it_fail is still
 > an int, we should now use simple_strtoul rather than simple_strtol,
 > proc_fault_inject_read()'s snprintf() should now use %u, etc.  None of
 > which actually matters, but still...
 
I toyed with the idea of changing task_struct.make_it_fail to unsigned too,
but only realized I missed that after I'd sent out the diff.

 > Rather than address all that I'm inclined to leave `make_it_fail' as an
 > int, turning your patch into a one-liner?

That works for me too.

	Dave

