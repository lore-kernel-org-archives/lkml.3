Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3G2UCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:02:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39734 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551Ab3G2UCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:02:46 -0400
Message-ID: <1375128164.2075.53.camel@joe-AO722>
Subject: Re: Checkpatch error on trace events macros
From: Joe Perches <joe@perches.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 13:02:44 -0700
In-Reply-To: <20130729195201.GC14883@xanatos>
References: <20130729195201.GC14883@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 12:52 -0700, Sarah Sharp wrote:
> Hi Andy and Joe,

Hi Sarah.

> Checkpatch is complaining when code adds new trace events macros:
> 
> sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
> Applying: xhci: add traces for debug messages in xhci_address_device()
> ERROR: Macros with complex values should be enclosed in parenthesis
> #86: FILE: drivers/usb/host/xhci-trace.h:15:
> +#define TRACE_SYSTEM xhci-hcd

<shrug>

I think these are suboptimal as the files should use
underscores rather than dashes.

checkpatch sees this as a subtraction which really
should have parentheses.

> ERROR: Macros with complex values should be enclosed in parenthesis
> #115: FILE: drivers/usb/host/xhci-trace.h:44:
> +#define TRACE_INCLUDE_PATH .
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #118: FILE: drivers/usb/host/xhci-trace.h:47:
> +#define TRACE_INCLUDE_FILE xhci-trace

Don't expect to checkpatch to be perfect.

It's not.

It's a stupid little tool good for some things
and good for highlighting areas that might need
another look.

Use your judgment about everything it spews.


