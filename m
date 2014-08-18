Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaHRJMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:12:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33226 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaHRJMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:12:44 -0400
Date: Mon, 18 Aug 2014 11:12:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818091239.GD25495@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407768567-171794-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> From: Ulrich Obergfell <uobergfe@redhat.com>
> 
> In some cases we don't want hard lockup detection enabled by default.
> An example is when running as a guest. Introduce
> 
>   watchdog_enable_hardlockup_detector(bool)

So, the name watchdog_enable_hardlockup_detector_enable(false) 
is both too long and also really confusing (because first it 
suggests enablement, then disables it), so I renamed it to 
hardlockup_detector_set(), which allows two natural variants:

	hardlockup_detector_set(false);
	...
	hardlockup_detector_set(true);

Thanks,

	Ingo
