Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaJGNYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:24:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45513 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaJGNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:24:38 -0400
Date: Tue, 7 Oct 2014 14:24:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] mnt: don't allow to detach the namespace root
Message-ID: <20141007132431.GF7996@ZenIV.linux.org.uk>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412683212-28077-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:00:12PM +0400, Andrey Vagin wrote:
> This patch fixes a bug, which is triggered by following code:
> while (1) {
>         if (umount2("/", MNT_DETACH) ||
> 	    setns(fd, CLONE_NEWNS))
>                 return break;
> }

Excuse me, but that makes no sense whatsoever (not to mention that
reproducer won't compile - return break; alone is enough to make
sure of that).

Could you post the real reproducer?
