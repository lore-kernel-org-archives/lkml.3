Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaEMWy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:54:26 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:64954 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEMWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <536CFC46.8010408@windriver.com>
References: <1399506651-20031-1-git-send-email-dianders@chromium.org>
	<536CFC46.8010408@windriver.com>
Date: Tue, 13 May 2014 15:54:16 -0700
X-Google-Sender-Auth: 9esKNFuGUrven3GBBzPg1W42n8o
Message-ID: <CAD=FV=XbcAUgcSm-E4ktys+pDzL9+BKqdC4zjgKS4C-QhLA-9Q@mail.gmail.com>
Subject: Re: [PATCH] init: Don't decrease loops_per_jiffy when a CPU comes up
From: Doug Anderson <dianders@chromium.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Stultz <john.stultz@linaro.org>
Cc: David Riley <davidriley@chromium.org>, Will Deacon <Will.Deacon@arm.com>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Fri, May 9, 2014 at 9:03 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On 14-05-07 07:50 PM, Doug Anderson wrote:
>> The loops_per_jiffy count continues to be updated as each CPU is
>> brought up.  This causes problems when we've got an HMP system and
>> different CPUs have different loops per jiffy.  On exynos 542x
>> systems, for instance, the A7s will have significantly lower loops per
>> jiffy than their big brothers.
>
> Based on the other discussion for the ARM variant of this, I'm
> assuming this also becomes a WFC issue.  And if not, then it
> probably should go by John or similar ; getmaintainers is just
> being dumb in spitting my name out, since I only made one
> trivial change to this file a year ago or similar.

I think this change could still make sense.  The ARM discussion is
about dealing with the scaling that the ARM code does, but it really
is a separate concept.

In general it seems like at least a warning is in order if
loops_per_jiffy changes significantly from CPU to CPU.
