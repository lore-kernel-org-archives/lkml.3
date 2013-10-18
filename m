Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3JRUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:09:46 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:61677 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3JRUJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <52610493.1000909@samsung.com>
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
	<1381876762-10892-3-git-send-email-dianders@chromium.org>
	<525E611A.6070708@imgtec.com>
	<CAD=FV=V4OPOjs=4cvXOomt1UnzUdw5VApkNAX2ERKZ46DC6_gg@mail.gmail.com>
	<CAAG0J98c6eA_c2McSvFcQUMUfPy-DgdHi7Te1tZqpT8XjjMQvw@mail.gmail.com>
	<52610493.1000909@samsung.com>
Date: Fri, 18 Oct 2013 13:09:28 -0700
X-Google-Sender-Auth: juFStmU7bDTQvIMjDQbj4hp57WE
Message-ID: <CAD=FV=WMMNA5xbwSrJebsLuw78sR1gtC0Yn+4FsA9HnvaNtk_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Protect read-modify-write of INTMASK
 with a lock
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: James Hogan <james.hogan@imgtec.com>, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon / James

On Fri, Oct 18, 2013 at 2:51 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> In this case it'd only be a space and code complexity thing I think. I
>> suppose in some cases the benefit of finer-grained locking is probably
>> pretty marginal, but there's a good case for it here. It might be
>> worth renaming the lock to irq_lock or something like that so it's
>> clear it doesn't have to protect only for INTMASK in the future - up
>> to you.
> It seems good that use the irq_lock than intmask_lock. (It's just naming)

Done in v2.
