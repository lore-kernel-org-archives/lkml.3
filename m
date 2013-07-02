Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3GBWXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:23:21 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49277 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3GBWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <73593d09ced9d2d64bebe0fb71e74ac00d8738c6.1372777600.git.ydroneaud@opteya.com>
References: <cover.1372777600.git.ydroneaud@opteya.com> <73593d09ced9d2d64bebe0fb71e74ac00d8738c6.1372777600.git.ydroneaud@opteya.com>
From: Erik Gilling <konkers@android.com>
Date: Tue, 2 Jul 2013 15:22:58 -0700
X-Google-Sender-Auth: GdGq8U3UoMTCasUUToSqxnQCWqI
Message-ID: <CACSP8SjZcpcpEtQHzcGYhf-MP7QGo0XpN7-uN7rmD=vNtopG=w@mail.gmail.com>
Subject: Re: [PATCH 04/13] android/sw_sync: use get_unused_fd_flags(0) instead
 of get_unused_fd()
To: Yann Droneaud <ydroneaud@opteya.com>, Colin Cross <ccross@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 9:39 AM, Yann Droneaud <ydroneaud@opteya.com> wrote:
>  static long sw_sync_ioctl_create_fence(struct sw_sync_timeline *obj,
>                                        unsigned long arg)
>  {
> -       int fd = get_unused_fd();
> +       int fd = get_unused_fd_flags(0);

I think we should use O_CLOEXEC here.  Colin and I can't think of any
case where one would want keep fences across exec.

Cheers,
   Erik
