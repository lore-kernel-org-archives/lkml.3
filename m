Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaCFNOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:14:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaCFNOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:14:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <11165.1393507178@warthog.procyon.org.uk>
References: <11165.1393507178@warthog.procyon.org.uk> <20140218205418.GH18768@katana> <20140109214954.25590.73057.stgit@warthog.procyon.org.uk> <20140109215002.25590.51609.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Wolfram Sang <wsa@the-dreams.de>,
        wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS
Date: Thu, 06 Mar 2014 13:13:55 +0000
Message-ID: <19542.1394111635@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > Can we have something like this for 'flags'?
> 
> There's a __print_flags() which should work.  One thing I'm concerned about
> there is how do we handle more flags being added - does that count as an ABI
> break if the printed format changes?
> 
> SMBus flags are basically the same as I2C flags, right?

Hmmm... __print_flags() seems to append a string if a flag is set, and doesn't
if it isn't set.  It places a separator between each string.  I would prefer
something that emits a single char per flag or a dash if it isn't present.
Are you okay with that?

David
