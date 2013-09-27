Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3I0Izu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:55:50 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:60843 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3I0Izs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1309261136010.312@syhkavp.arg>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
	<1380207292-16968-10-git-send-email-ulf.hansson@linaro.org>
	<alpine.LFD.2.03.1309261136010.312@syhkavp.arg>
Date: Fri, 27 Sep 2013 10:55:47 +0200
Message-ID: <CAPDyKFobK48HLh=u+RLoGLH2+tsK-FKCKFMUh0Y4oFLbXBAqRw@mail.gmail.com>
Subject: Re: [PATCH 09/27] mmc: mvsdio: Remove redundant suspend and resume callbacks
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 17:40, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 26 Sep 2013, Ulf Hansson wrote:
>
>> Suspend and resume of cards are handled by the protocol layer and
>> consequently the mmc_suspend|resume_host APIs are marked as deprecated.
>
> Having the protocol layer take care of card suspend is perfectly sound.
>
> However, what about host controllers?  Shouldn't they suspend themselves
> as well?  There is certainly potential for power saving by gating clocks
> to the host IP block or the like.
>

Hi Nicolas,

You are right, host drivers shall be responsible to handle power
saving operations, like clocks, power domains, pinctrls, etc. In many
cases I think using only runtime PM should satisfy a host driver's
need to perform the proper power saving.

For mvsdio, there were no host power save operations done in the
suspend/resume callbacks, which is why I removed the callbacks
entirely.

Kind regards
Ulf Hansson

>
> Nicolas
