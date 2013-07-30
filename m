Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3G3B7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:59:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59459 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062Ab3G3B67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:58:59 -0400
Message-ID: <1375149538.2075.95.camel@joe-AO722>
Subject: Re: Checkpatch error on trace events macros
From: Joe Perches <joe@perches.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 18:58:58 -0700
In-Reply-To: <51F7171C.4060100@huawei.com>
References: <20130729195201.GC14883@xanatos> <51F7171C.4060100@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 09:30 +0800, Li Zefan wrote:
> On 2013/7/30 3:52, Sarah Sharp wrote:
> > Hi Andy and Joe,
> > 
> > Checkpatch is complaining when code adds new trace events macros:
> > 
> > sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
> > Applying: xhci: add traces for debug messages in xhci_address_device()
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #86: FILE: drivers/usb/host/xhci-trace.h:15:
> > +#define TRACE_SYSTEM xhci-hcd
> > 
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #115: FILE: drivers/usb/host/xhci-trace.h:44:
> > +#define TRACE_INCLUDE_PATH .
> > 
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #118: FILE: drivers/usb/host/xhci-trace.h:47:
> > +#define TRACE_INCLUDE_FILE xhci-trace
> > 
> > total: 3 errors, 0 warnings, 169 lines checked
> > 
> > 
> > The macros have to be defined that way for trace events to work.
> 
> yeah, that's true, and we always just ignore chechpatch complaints
> when it comes to TRACE_EVENT macros.
> 
> > Can you fix checkpatch not to complain about trace event macros?
> > 

So what are these TRACE_<FOO> defines that need
excluding from the "complex values" check?

Anything other than 

TRACE_SYSTEM
TRACE_INCLUDE_FILE
TRACE_INCLUDE_PATH

?

samples/trace_events/trace-events-sample.h
only has those 3.



