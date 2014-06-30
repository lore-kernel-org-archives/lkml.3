Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbaF3Uku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:40:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:14959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbaF3Ukr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:40:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,577,1400050800"; 
   d="scan'208";a="536762965"
From: Andi Kleen <andi@firstfloor.org>
To: David Drysdale <drysdale@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<1404124096-21445-2-git-send-email-drysdale@google.com>
Date: Mon, 30 Jun 2014 13:40:40 -0700
In-Reply-To: <1404124096-21445-2-git-send-email-drysdale@google.com> (David
	Drysdale's message of "Mon, 30 Jun 2014 11:28:01 +0100")
Message-ID: <87mwcuw2pj.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Drysdale <drysdale@google.com> writes:

> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
> provided path, rejecting (with -EACCES) paths that are not beneath
> the provided dfd.  In particular, reject:
>  - paths that contain .. components
>  - paths that begin with /
>  - symlinks that have paths as above.

How about bind mounts?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
