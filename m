Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaACRPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:15:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaACRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:15:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1388769034.20141.11.camel@x220>
References: <1388769034.20141.11.camel@x220> <1388766184.20141.6.camel@x220> <20140103160812.8153.74401.stgit@warthog.procyon.org.uk> <9629.1388766864@warthog.procyon.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mei: mei-amt-version: remove unneeded call of mei_deinit()
Date: Fri, 03 Jan 2014 17:14:59 +0000
Message-ID: <25291.1388769299@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> wrote:

> From: Paul Bolle <pebolle@tiscali.nl>
> 
> Building mei-amt-version.o triggers a GCC warning:
>     Documentation/misc-devices/mei/mei-amt-version.c: In function 'main':
>     Documentation/misc-devices/mei/mei-amt-version.c:103:5: warning: 'acmd.fd' is used uninitialized in this function [-Wuninitialized]
>       if (cl->fd != -1)
>          ^
>     Documentation/misc-devices/mei/mei-amt-version.c:443:21: note: 'acmd.fd' was declared here
>       struct amt_host_if acmd;
>                          ^
> 
> GCC is correct. See, the call chain that GCC detects must be
>     main()
>         amt_host_if_init()
>             mei_init()
>                 mei_deinit()
> 
> But when we enter mei_deinit() struct amt_host_if acmd is still
> unitialized. That makes the test for (effectively) amt_host_if->mei_cl->fd
> bogus.
> 
> But it turns out that call of mei_deinit() isn't needed at all. All of
> the members of mei_cl will be set later in mei_init() and none will be
> used before they are set. So we can simply drop this call of
> mei_deinit().
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Builds without warning for me.

Acked-by: David Howells <dhowells@redhat.com>
