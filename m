Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab3FRQzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:55:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56658 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933032Ab3FRQzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:55:48 -0400
X-Sasl-enc: PZ1jfHnsrbSPJiyyQJDGbZSRd76n7L/7dI3EwOYo738b 1371574546
Date: Tue, 18 Jun 2013 09:55:45 -0700
From: Greg KH <greg@kroah.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: Skip key state checks when checking for possession
Message-ID: <20130618165545.GA29639@kroah.com>
References: <20130618164722.23443.23372.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618164722.23443.23372.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 05:47:22PM +0100, David Howells wrote:
> Skip key state checks (invalidation, revocation and expiration) when checking
> for possession.  Without this, keys that have been marked invalid, revoked
> keys and expired keys are not given a possession attribute - which means the
> possessor is not granted any possession permits and cannot do anything with
> them unless they also have one a user, group or other permit.
> 
> This causes failures in the keyutils test suite's revocation and expiration
> tests now that commit 96b5c8fea6c0861621051290d705ec2e971963f1 reduced the
> initial permissions granted to a key.
> 
> The failures are due to accesses to revoked and expired keys being given
> EACCES instead of EKEYREVOKED or EKEYEXPIRED.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/keys/internal.h         |    1 +
>  security/keys/process_keys.c     |    8 +++++---
>  security/keys/request_key.c      |    6 ++++--
>  security/keys/request_key_auth.c |    2 +-
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
