Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbbAEQAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:00:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbAEQAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:00:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1419863941-16403-1-git-send-email-sasha.levin@oracle.com>
References: <1419863941-16403-1-git-send-email-sasha.levin@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        keyrings@linux-nfs.org (open list:KEYS/KEYRINGS:),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: Re: [PATCH] KEYS: close race between key lookup and freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30931.1420473588.1@warthog.procyon.org.uk>
Date: Mon, 05 Jan 2015 15:59:48 +0000
Message-ID: <30932.1420473588@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> wrote:

> When a key is being garbage collected, it's key->user would get put before
> the ->destroy() callback is called, where the key is removed from it's
> respective tracking structures.
> 
> This leaves a key hanging in a semi-invalid state which leaves a window open
> for a different task to try an access key->user. An example is
> find_keyring_by_name() which would dereference key->user for a key that is
> in the process of being garbage collected (where key->user was freed but
> ->destroy() wasn't called yet - so it's still present in the linked list).
> 
> This would cause either a panic, or corrupt memory.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied.
