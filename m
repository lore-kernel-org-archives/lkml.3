Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3GBWWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:22:31 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60463 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3GBWWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <747eab1873d0e8285a243ed42540485f12af1e91.1372777600.git.ydroneaud@opteya.com>
References: <cover.1372777600.git.ydroneaud@opteya.com> <747eab1873d0e8285a243ed42540485f12af1e91.1372777600.git.ydroneaud@opteya.com>
From: Erik Gilling <konkers@android.com>
Date: Tue, 2 Jul 2013 15:22:08 -0700
X-Google-Sender-Auth: QBQebeB2GNKfOFVC7kkOHd_Zrnk
Message-ID: <CACSP8SjXGMk2_kX_+RgzqqQwqKernvF1Wt3K5tw991W5dfAnCA@mail.gmail.com>
Subject: Re: [PATCH 05/13] android/sync: use get_unused_fd_flags(0) instead of get_unused_fd()
To: Yann Droneaud <ydroneaud@opteya.com>, Colin Cross <ccross@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 9:39 AM, Yann Droneaud <ydroneaud@opteya.com> wrote:
>  static long sync_fence_ioctl_merge(struct sync_fence *fence, unsigned long arg)
>  {
> -       int fd = get_unused_fd();
> +       int fd = get_unused_fd_flags(0);

I think we should use O_CLOEXEC here.  Colin and I can't think of any
case where one would want keep fences across exec.

Cheers,
   Erik
