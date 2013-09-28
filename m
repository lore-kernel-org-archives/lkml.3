Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3I1BEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 21:04:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42600 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654Ab3I1BDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 21:03:15 -0400
X-Sasl-enc: 8dZgUdjA+oHKh3Fj3lPHIwykVu/WQiUHwr1Us8ZR4yUY 1380330194
Date: Fri, 27 Sep 2013 18:04:24 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-ID: <20130928010424.GB22939@kroah.com>
References: <20130927182117.42cdf5287fa1e9b40dd3f8e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927182117.42cdf5287fa1e9b40dd3f8e9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 06:21:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/tty/serial/8250/8250_dw.c: In function 'dw8250_probe':
> drivers/tty/serial/8250/8250_dw.c:341:3: error: too many arguments to function 'dw8250_probe_acpi'
>    err = dw8250_probe_acpi(&uart, data);
>    ^
> drivers/tty/serial/8250/8250_dw.c:281:19: note: declared here
>  static inline int dw8250_probe_acpi(struct uart_8250_port *up)
>                    ^
> 
> Caused by commit fe95855539fd ("serial: 8250_dw: don't limit DMA support
> to ACPI") from the tty tree.
> 
> I have reverted that commit for today (and commit 7fb8c56c7fa0 ("serial:
> 8250_dw: provide a filter for DMA channel detection") that depends on it).

Should now be fixed, thanks.

greg k-h
