Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3BYRLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:11:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3BYRLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:11:44 -0500
Date: Mon, 25 Feb 2013 18:10:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/1] usermodehelper: cleanup/fix __orderly_poweroff() &&
	argv_free()
Message-ID: <20130225171014.GB1024@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Lucas De Marchi wrote:
>
> it was risking running the cleanup twice (like
> kernel/sys.c:orderly_poweroff()) and if not, a leak could happen.

As for kernel/sys.c:orderly_poweroff(), it simply doesn't need
argv_cleanup() and -ENOMEM check, see 1/1.

Oleg.

