Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3JCVP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:15:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3JCVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:15:25 -0400
Date: Thu, 3 Oct 2013 14:15:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Stephen Warren <swarren@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 1/2] init/do_mounts.c: ignore final \n in
 name_to_dev_t
Message-Id: <20131003141523.8b60ab988799af7e2b2c338b@linux-foundation.org>
In-Reply-To: <1380834638-24035-2-git-send-email-sebastian.capella@linaro.org>
References: <1380834638-24035-1-git-send-email-sebastian.capella@linaro.org>
	<1380834638-24035-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Oct 2013 14:10:37 -0700 Sebastian Capella <sebastian.capella@linaro.org> wrote:

> Enhance name_to_dev_t to handle trailing newline characters
> on device paths.  Some inputs to name_to_dev_t may come from
> userspace where oftentimes a '\n' is appended to the path.
> Added const to the name buffer in both the function
> declaration and the prototype to reflect input buffer
> handling.
> 
> By handling trailing newlines in name_to_dev_t, userspace
> buffers may be directly passed to name_to_dev_t without
> modification.

We have lib/string.c:strim() - perhaps this patch would be
neater if it were to use it?
