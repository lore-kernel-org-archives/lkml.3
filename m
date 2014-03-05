Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaCEEP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:15:59 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37019 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaCEEP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:15:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140305040929.GA31130@kroah.com>
References: <1393991871-1743-1-git-send-email-roland@kernel.org> <20140305040929.GA31130@kroah.com>
From: Roland Dreier <roland@kernel.org>
Date: Tue, 4 Mar 2014 20:15:36 -0800
X-Google-Sender-Auth: DgvX_2i-Q_lbjQUIIAJsyZarrRM
Message-ID: <CAG4TOxONSsyokdy9Sw+fT21QA7E-uY572ZDoNf3V9f7D1ytyxQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "driver core: synchronize device shutdown"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, shli@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, no one seems to have said anything for the past 5 years about this.

It definitely is hard to hit -- you have to do "shutdown" or "reboot"
right as something schedules async work.  In our case we have some
systems with a large and slightly flaky SAS fabric, so there's a
constant level of re-probing SCSI disks, and we occasionally see
reboots hanging due to waiting for never-finishing sd probe async
work.

AFAICT the synchronization does nothing useful and is just a remnant
of a patch series where the real meat didn't get applied.  But of
course it would be great if Shaohua could confirm my understanding.

Thanks,
  Roland
