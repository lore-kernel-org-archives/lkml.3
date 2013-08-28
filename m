Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3H1WBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:01:02 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46919 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3H1WA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <16805669.URyPi50bbV@vostro.rjw.lan>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
	<16805669.URyPi50bbV@vostro.rjw.lan>
Date: Wed, 28 Aug 2013 15:00:58 -0700
X-Google-Sender-Auth: R4S9pfF-jYcsNbOGZeRj5-P-hb0
Message-ID: <CAMbhsRQ4DtMUs7HJz_t4reWaehjqEN=Xg2EaFKBgdPUO_ZtNCA@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering
 safe state
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Neil Zhang <zhangwm@marvell.com>,
        Joseph Lo <josephl@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>, stable@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 2:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 23, 2013 12:45:10 PM Colin Cross wrote:
>> Calling cpuidle_enter_state is expected to return with interrupts
>> enabled, but interrupts must be disabled before starting the
>> ready loop synchronization stage.  Call local_irq_disable after
>> each call to cpuidle_enter_state for the safe state.
>>
>> CC: stable@vger.kernel.org
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> I've queued up all thress for 3.12, but I wonder what stable versions they
> should be included into?  All of them or just a subset?

The patches apply cleanly back to v3.6.

Joseph Lo had 2 minor comments on patch 2 (changing Tegra3 to Tegra20
in the commit message, replacing cpuidle_coupled_poke_pending with
cpuidle_coupled_poked in the comment above cpuidle_coupled_poked), do
you want to fix those up locally or should I resend the series?
