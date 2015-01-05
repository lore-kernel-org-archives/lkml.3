Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbAEBMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:12:17 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59401 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbbAEBMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:12:16 -0500
MIME-Version: 1.0
In-Reply-To: <1419979410-7589-3-git-send-email-jonathar@broadcom.com>
References: <jonathar@broadcom.com>
	<1419979410-7589-1-git-send-email-jonathar@broadcom.com>
	<1419979410-7589-3-git-send-email-jonathar@broadcom.com>
Date: Sun, 4 Jan 2015 17:12:14 -0800
Message-ID: <CAD7vxxKb-JvBMzEoJ3m8xsrHJ4KhDqViWhtH-7sBpA-jJgic1w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] pwm: kona: Remove setting default smooth type and
 polarity for all channels
From: Tim Kryger <tim.kryger@gmail.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pwm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 2:43 PM, Jonathan Richardson
<jonathar@broadcom.com> wrote:
> Setting the default polarity in probe to normal for all channels caused
> the speaker pwm channel to click. The polarity does need to be set to
> normal because the hw default is inversed whereas the pwm framework
> defaults to normal. If a channel is enabled without setting the polarity
> then the signal would be inversed while linux reports normal. A check
> is now done prior to enabling the channel to ensure that the hw polarity
> matches the desired polarity and is changed if there is a discrepency. This
> prevents unnecessary settings being applied to unused channels but still
> ensures the correct polarity to be set.

A more direct solution that avoids the potentially undesirable
consequences of delaying when polarity changes are written to hardware
would be to update the PWM framework to allow for the registration of
chips with inversed default polarity.

I will post a patch for your review.
