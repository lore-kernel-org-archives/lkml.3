Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3LRXsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:48:42 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41461 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3LRXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:48:41 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Date: Wed, 18 Dec 2013 15:48:37 -0800
Message-ID: <1950536.BXYYX85NB4@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.11.3 (Linux/3.11.9-200.fc19.x86_64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131218234009.GA9360@yabbi.redhat.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com> <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com> <20131218234009.GA9360@yabbi.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 19, 2013 09:40:09 AM Peter Hutterer wrote:
> > +     memset(&abs, 0, sizeof(abs));
> > +     for (i = valid_cnt; i < cnt; ++i)
> > +             if (copy_to_user(&pinfo->info[i], &abs, sizeof(abs)))
> > +                     return -EFAULT;
> > +
> > +     return 0;
> 
> why don't you return the number of valid copied axes to the user?
> that seems better even than forcing the remainder to 0.

Well, if your program messed up buffers that it faulted we do not know
for sure if data that did not cause fault ended up where it should have
or if it smashed something else. This condition I think should be
signaled early.

-- 
Dmitry
