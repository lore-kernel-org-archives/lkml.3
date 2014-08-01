Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaHAQyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:54:21 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62877 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaHAQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
References: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
Date: Fri, 1 Aug 2014 09:54:18 -0700
X-Google-Sender-Auth: PLg25ygHU3tdArzUgwIKtM_-tXQ
Message-ID: <CAA9_cmfc7_d_s9XjeyqY_T6uZPbWjY0Dw=2aeFbL+9hCu8k_aA@mail.gmail.com>
Subject: Re: [PATCH RFC] sysfs: fix the race of "parent deleted before child added"
From: Dan Williams <dan.j.williams@intel.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jianyu Zhan <Jianyu.Zhan@emc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 4:18 AM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> From: Jianyu Zhan <Jianyu.Zhan@emc.com>
>
> I've met such a race conditon the same as what commit 3a198886
> ("sysfs: handle 'parent deleted before child added'") tackled.
>
> The senario got triggered under a torturing test of quick disk
> removal and plugging.
>
> The forementioned commit 3a198886 didn't really fix this race,
> it just narrows down the racy window.

You misread the changelog.  It was never meant to be a fix, its there
to prevent abuses from crashing this system and rather return an
error.

The commit that fixed the race I was seeing is here:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3b661a92

Perhaps you have found another occasion where a device is being
device_del()'d right before a device_add() attempt?
