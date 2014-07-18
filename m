Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbaGRPd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:33:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47070 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030618AbaGRPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:33:26 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
	<1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
Date: Fri, 18 Jul 2014 17:33:23 +0200
Message-ID: <CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
Subject: Re: [PATCH 3/3] fuse: Allow mounts from user namespaces
From: Miklos Szeredi <miklos@szeredi.hu>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> Update fuse to allow mounts from user namespaces. During mount
> current_user_ns() is stashed away,

Same thing here.  While practically this may work, it's theoretically
wrong, and possibly may go wrong in special situations.   In fuse
there's no official "server process", so storing information, like
namespace, about one is going to be wrong.

Thanks,
Miklos
