Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3CFNng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:43:36 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45782 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3CFNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:43:34 -0500
MIME-Version: 1.0
In-Reply-To: <51371B5E.1000508@free-electrons.com>
References: <51371B5E.1000508@free-electrons.com>
Date: Wed, 6 Mar 2013 15:43:32 +0200
X-Google-Sender-Auth: j-hXa6n0xSvQ2aQowASHqyfgXOI
Message-ID: <CAB7JpEHJdKeOhkME-6mMdPY6VyTQwFvM33+gxg4X9ZpQv1=6RQ@mail.gmail.com>
Subject: Re: v3.9-rc1: swapper/0 [ INFO: possible circular locking dependency
 detected ]
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2013 12:33, Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> Just noticed this in 3.9-rc1 on an iMX28 (ARM) board with a config
> based on mxs_defconfig. I'm using the patchset "Add tested id switch
> and vbus connect detect support for Chipidea" from Peter Chen in its
> 10th version [1], rebased on top of 3.9-rc1, but since this doesn't
> modify the locks present in the udc_irq function, I think the problem
> is elsewhere.

>From a quick look at the current chipidea code, I don't see any place
where we might try to take cdev->lock under ci->lock. I should have a
better look at Peter's patchset to see if it can trigger that. Peter,
have you seen anything like that with your code?
Is this easy to trigger (I would assume it is)? Can you post the
contents of "events" debug file in sysfs?

Thanks,
--
Alex
