Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3DWQqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:46:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab3DWQqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:46:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130403144857.22351.67546.stgit@rabbit.intern.cm-ag>
References: <20130403144857.22351.67546.stgit@rabbit.intern.cm-ag>
To: Max Kellermann <mk@cm4all.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscache: extended "dying" check before emitting EV_INVALIDATE
Date: Tue, 23 Apr 2013 17:46:40 +0100
Message-ID: <5617.1366735600@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann <mk@cm4all.com> wrote:

> +			    (object->events & (FSCACHE_OBJECT_EV_RETIRE|FSCACHE_OBJECT_EV_RELEASE)) == 0)

You can't do it like this.  EV_RETIRE and EV_RELEASE are bit numbers, so need
to be shifted into place.

David
