Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3LPRpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:45:24 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:48778 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPRpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:45:22 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
Date: Mon, 16 Dec 2013 09:45:22 -0800
Message-ID: <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 7:00 AM, Li Wang <liwang@ubuntukylin.com> wrote:
> This patch extend the 'drop_caches' interface to
> support directory level cache cleaning and has a complete
> backward compatibility. '{1,2,3}' keeps the same semantics
> as before. Besides, "{1,2,3}:DIRECTORY_PATH_NAME" is allowed
> to recursively clean the caches under DIRECTORY_PATH_NAME.
> For example, 'echo 1:/home/foo/jpg > /proc/sys/vm/drop_caches'
> will clean the page caches of the files inside 'home/foo/jpg'.
>

This interface is ugly...

And we already have a file-level drop cache, that is,
fadvise(DONTNEED). Can you extend it if it can't
handle a directory fd?
