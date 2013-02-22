Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3BVKud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:50:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab3BVKua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:50:30 -0500
Date: Fri, 22 Feb 2013 11:50:26 +0100
From: Michal Marek <mmarek@suse.cz>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, jespern@axis.com
Subject: Re: [PATCH] kbuild: Fix destination-y for installed headers
Message-ID: <20130222105026.GG12402@pobox.suse.cz>
References: <20130202101835.GY23529@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202101835.GY23529@axis.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 11:18:35AM +0100, Jesper Nilsson wrote:
> Commit 10b63956fce7f369cc37fd4d994f09bd5203efe4 which plumbed in UAPI
> broke the destination-y functionality of scripts/Makefile.headersinst.
> 
> The variable destination-y is used in a := assignment and so is expanded at
> declaration time, and the include of the Kbuild fragments that set
> destination-y to something is after this time, so it now always expands empty.
> 
> There are no in-tree users of destination-y, but it allows any
> Kbuild-fragment to redirect where headers are installed.
> 
> Just move the assignment of the variable that uses it below the include
> of the Kbuild fragment.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  Makefile.headersinst |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git scripts/Makefile.headersinst scripts/Makefile.headersinst

I applied your patch to kbuild.git#kbuild, but please send -p1 patches
next time.

Michal
