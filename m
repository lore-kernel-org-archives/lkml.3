Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3GQOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:48:58 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:55324 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507Ab3GQOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:48:56 -0400
Date: Wed, 17 Jul 2013 14:48:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel@pengutronix.de,
        Steven Rostedt <srostedt@redhat.com>
Subject: Re: configurable partial slab support on UP
In-Reply-To: <CAOJsxLH8KftyLyRUtAt5-UpTve36pcfnMbVK=5hayQO4RsGLvw@mail.gmail.com>
Message-ID: <0000013fed1af946-585e45ff-7b31-4b95-a9fc-76baa380d43d-000000@email.amazonses.com>
References: <20130716191030.GA31335@pengutronix.de> <CAOJsxLH8KftyLyRUtAt5-UpTve36pcfnMbVK=5hayQO4RsGLvw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.17-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Pekka Enberg wrote:

> > while doing make oldconfig on an !SMP config using 3.11-rc1 I was asked
> > if I want CONFIG_SLUB_CPU_PARTIAL. AFAICT this setting only affects SMP
> > machines? If so I suggest to make the choice depend on SMP and treat the
> > !SMP case as CONFIG_SLUB_CPU_PARTIAL=n.

Sounds ok.
> >
> > This was introduced in commit
> >         345c905 (slub: Make cpu partial slab support configurable)
>
> The per-CPU partial list is used on UP machines as well so the config
> option does affect them. Whether or not they should be used is another
> topic entirely. Christoph, Joonsoo?

cpu partial pages are used to avoid contention which does not exist in the
UP case. We can simply default to off for UP.

